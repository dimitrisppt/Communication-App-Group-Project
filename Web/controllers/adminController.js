var fs = require('fs'); 
var { body, validationResult } = require('express-validator/check'); 
var { sanitizeBody } = require('express-validator/filter'); 
var debug = require('debug'); 
var firebase = require('../models/firebase'); 

/**
 * Retrieve all admin objects from firebase, and pass to admins view for it display in a list 
 */
exports.admins_get = function(req, res) {

	firebase.refAdmins.once('value').then(function(snapshot) {
		if (snapshot.val()) {
			var adminListEntries = Object.entries(snapshot.val()); 
			var adminObjects = adminListEntries.map(function(entry) {
				return {
					firebaseKey: entry[0],
					name: entry[1].name, 
					email: entry[1].email
				}; 
			}); 

			var errorMessage; 
			if (req.params.errorCode == 0) {
				errorMessage = 'You are not authorised to remove admins from list!'; 
			} else if (req.params.errorCode == 1) {
				errorMessage = 'You are not authorised to add admins to the list!';
			} 

			var status = errorMessage ? 400 : 200; 
			res.status(status).render('admins', { title: 'List of administrators', 
									adminsList: adminObjects, 
									error: errorMessage,
									superAdminLogged: req.session.isSuperAdmin } ); 
		} else {
			res.render('admins', { title: 'List of administrators', adminsList: [], error: 'Trouble retrieving administrators\' data' }); 
		}
	}).catch(err => console.log(err)); 
	
}; 

/**
 * Deletes an admin from firebase
 */
exports.admin_delete = function(req, res) {
	if (req.session.isSuperAdmin) {
		firebase.deleteAdmin(req.params.key)
		res.status(200).redirect('/admins') 
	} else {
		res.status(400).redirect('/admins/error/0'); 
	}
}

/**
 * Displays page for superadmins allowing to add new admins
 */
exports.admin_new_get = function(req, res) {
	if (req.session.isSuperAdmin) {
		var feedbacks = {errors: [], messages: [] }; 
		renderNewAdmin(res, feedbacks); 
	} else {
		res.redirect('/admins/error/1'); 
	}
}; 

/*
 * Posts data about a new admin to firebase 
 */
exports.admin_new_post = [

	body('name', 'Admin must have a name').isLength({min: 1}), 
	body('email', 'Admin must have an email').isLength({min: 1}), 

	// Trim (remove spaces), and escape (escape all html)
	sanitizeBody('name').trim().escape(), 

	(req, res, next) => {

		if (req.session.isSuperAdmin) {

			const allErrors = validationResult(req).array(); 

			if (allErrors.length > 0) {
				debug('Error(s) in creating a user'); 			
				res.status(400) // bad request; 
					.render('newAdmin', { title: 'Register new admin', feedbacks: { errors: allErrors, messages: [] } }); 
			} else {
				addAdminToList(req.body.name, req.body.email); 
				var feedbacks = { errors: [], messages: ['New staff member was added successfully'] };  
				renderNewAdmin(res, feedbacks); 
			}
		} else {
			res.redirect('/admins/error/1'); 
		}
	}
]; 

/**
 * Displays page to register a new admin
 * @param {Array[String]} feedbacks List of messages to display
 */
function renderNewAdmin(res, feedbacks) {
	res.render('newAdmin', { title: 'Register new admin', feedbacks: feedbacks }); 
}

/**
 * Helper method to add new admin object to firebase when the attributes are specified 
 * @param {string} name Name of new admin
 * @param {string} email email of new admin
 */
function addAdminToList(name, email) {
	firebase.newAdmin(name, email);
}

