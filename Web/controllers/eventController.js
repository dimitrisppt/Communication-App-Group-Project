var fs = require('fs'); 
var { body, validationResult } = require('express-validator/check'); 
var { sanitizeBody } = require('express-validator/filter'); 
var debug = require('debug'); 
var firebase = require('../models/firebase'); 

/**
* Obtains data on all events and displays the page listing all events
*/
exports.event_get = function(req, res) {
	firebase.eventRef.once('value').then(function(snapshot) {
		if (snapshot.val()) {
			var eventEntries = Object.entries(snapshot.val()); 
			var eventObjects =eventEntries.map(function(entry) {
				return {
					firebaseKey: entry[0],
					location: entry[1].location,
					date: entry[1].day,
					start: entry[1].starttime,
					end: entry[1].endtime,
					title: entry[1].title,
					desc: entry[1].desc
				}; 
			}); 

			var errorMessage; 
			if (req.params.errorCode == 0) {
				errorMessage = 'You are not authorised to remove admins from list!'; 
			} else if (req.params.errorCode == 1) {
				errorMessage = 'You are not authorised to add admins to the list!';
			} 

			var status = errorMessage ? 400 : 200; 
			res.status(status).render('event', { event: eventObjects, 
									error: errorMessage
									} ); 
		} else {
			res.render('event', { event: [] }); 
		}
	}).catch(err => console.log(err)); 
	
}; 

/**
* Deletes an event
*/
exports.event_delete = function(req, res) {
	firebase.deleteEvent(req.params.key)
	res.status(200).redirect('/event') 
}

