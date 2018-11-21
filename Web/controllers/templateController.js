var fs = require('fs'); 
var { body, validationResult } = require('express-validator/check'); 
var { sanitizeBody } = require('express-validator/filter'); 
var debug = require('debug'); 
var firebase = require('../models/firebase'); 

/*
* Edits a given template
*/
exports.template_edit = function(req, res) {
	if (req.params.key) {
		res.render('templates', { title: 'Edit template', feedbacks: { errors: [], messages: [] }, 
									formUrl: '/templates/edit-form/' + req.params.key
								}); 	
	} else {
		failedTemplate(req, res, ["Cannot find template to edit"]); 
	}
}; 


/*
* Displays the form used to edit a template
*/
exports.template_edit_form = function(req, res) {
	if (req.params.key) {
		firebase.templateRef.once('value').then(snapshot => {
			if(snapshot.val()) {
				var templateListEntries = Object.entries(snapshot.val()); 
				var templateMap = new Map([]); 

				templateListEntries.forEach(entry => {
					templateMap.set(entry[0], entry[1]); 
				});
				var requestedTemplate = templateMap.get(req.params.key); 
				
				if (!requestedTemplate) {
					failedTemplate(req, res, ['Cannot retrieve template from firebase']); 
					return; 
				}
				res.render('templateForm', {  title: 'Template form', feedbacks: { errors: [],
												 messages: [] },
								 key: req.params.key,
								 requestName: requestedTemplate.name,
								 requestContent: requestedTemplate.content, }); 

			} else {
				failedTemplate(req, res, ['Cannot retrieve template from firebase']); 
			}
		}); 
	} else {
		failedTemplate(req, res, ["Cannot find template to edit"]); 
	}
}; 


/* 
 * Retrieve all template objects from firebase, and pass to admins view for it display in a list 
 */

exports.template_new_get = function(req, res) {
	firebase.templateRef.once('value').then(function(snapshot) {
	if (snapshot.val()) {
		var templateListEntries = Object.entries(snapshot.val()); 
		var templateMap = new Map([]); 
		var templateObjects = templateListEntries.forEach(function(entry) {
		var firebaseKey = entry[0];
		templateMap.set(firebaseKey, {
			firebaseKey: entry[0],
			name: entry[1].name,
	      	content: entry[1].content,
			})
		}); 
		var templateToShow = templateMap.get(req.params.key)

		res.render('viewAnnouncement', { title: 'New Template', 
									  template: templateToShow
										})
	} else {
			
	}
	}).catch(err => console.log(err)); 

	res.render('templates', { title: 'New template', feedbacks: { errors: [], messages: [] } });  
}; 


/**
* Posts a new template
*/
exports.template_new_post = [

	body('name', 'template must have a name').isLength({min: 1}), 
	body('content', 'template must have a content').isLength({min: 1}),
	// Trim (remove spaces), and escape (escape all html)
	sanitizeBody('name').trim().escape(), 
	sanitizeBody('content').trim().escape(), 

	(req, res, next) => {
			const allErrors = validationResult(req).array(); 
			var template = {
				key: req.body.key,
				name: req.body.name,
				content: req.body.content,
			}

			if (allErrors.length > 0) {
				failedTemplate(req, res, allErrors); 
			} else {
				addTemplateToList(res , template); 
				var feedbacks = { errors: [], messages: ['New template was added successfully'] };  
				renderNewTemplate(res, feedbacks); 
			}
	}
]; 

/** 
 * Takes an incomplete request, responds with status 400 BAD REQUEST, 
 * and re-displays the template form with the given allErrors. 
 */ 
function failedTemplate(req, res, allErrors) {
	debug('Error(s) in creating a post'); 			
		res.status(400) // bad request; 
			.render('templateForm', {  title: 'Template form', feedbacks: { errors: allErrors,
												 messages: [] },
								 requestName: req.body.name,
								  }
			); 
}

/**
 * Displays the form used to create a new template
 */
function renderNewTemplate(res, feedbacks) {
	res.render('templateForm', { title: 'Create a new template', feedbacks: feedbacks }); 
}

exports.template_form = function(req, res) {
	res.render('templateForm', { title: 'Template form', feedbacks: { errors: [],
										messages: [] } }); 
}


/**
 *  Adds or edits a new template to firebase
 * @param {object} content content of the template
 */

function addTemplateToList(res,template) {
	firebase.newTemplate(template.key ,template);
}

