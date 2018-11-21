var fs = require('fs'); 
var { body, validationResult } = require('express-validator/check'); 
var { sanitizeBody } = require('express-validator/filter'); 
var debug = require('debug'); 
var firebase = require('../models/firebase'); 

/**
* Obtains data on all templates and displays the page listing all templates
*/
exports.template_get = function(req, res) {
	firebase.templateRef.once('value').then(function(snapshot) {
		if (snapshot.val()) {
			var templateListEntries = Object.entries(snapshot.val()); 
			var templateObjects =templateListEntries.map(function(entry) {
				return {
					firebaseKey: entry[0],
					name: entry[1].name,
      				content: entry[1].content
				}; 
			}); 
			var errorMessage; 
			if (req.params.errorCode == 0) {
				errorMessage = 'You are not authorised to remove a template from list!'; 
			} else if (req.params.errorCode == 1) {
				errorMessage = 'You are not authorised to add a template to the list!';
			} 

			var status = errorMessage ? 400 : 200; 
			res.status(status).render('listOfTemplate', { templateList: templateObjects, 
									error: errorMessage
									} ); 
		} else {
			res.render('listOfTemplate', { templateList: [] }); 
		}
	}).catch(err => console.log(err)); 
	
};

/**
* Renders the form showing details about a template
*/
exports.template_form = function(req,res) {

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

			var templateToShow = templateMap.get(req.params.key);

			res.render('templateListForm', { title: 'template detail', 
									  template: templateToShow
										})
		} else {
			
		}
	}).catch(err => console.log(err)); 
}

/**
* Displays the page containing the form with all information about a specific template
*/
exports.template_detail = function(req, res) {
	
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

			var templateToShow = templateMap.get(req.params.key); 
			res.render('viewTemplates', { title: 'template detail', 
									  template: templateToShow
										})
		} else {
			
		}
	}).catch(err => console.log(err)); 
}

/**
* Deletes a specific template
*/
exports.template_delete = function(req, res) {
	firebase.deleteTemplate(req.params.key)
	res.status(200).redirect('/templateList') 
}


