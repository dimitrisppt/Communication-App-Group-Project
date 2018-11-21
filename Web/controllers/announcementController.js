var { body, validationResult } = require('express-validator/check'); 
var { sanitizeBody } = require('express-validator/filter'); 
var firebase = require('../models/firebase'); 
var debug = require('debug')('announcement'); 
var fs = require('fs');
var dateTime = require('node-datetime'); 

var xlsxParser = require('../models/xlsxParser.js');  
var path = require('path'); 

/**
 * Renders the index view 
 */
exports.announce_get = function(req, res) {
	res.render('index', { title: 'New announcement', feedbacks: { errors: [], messages: [] } });  
}; 

/**
* Renders the page for the edition of an announcement
*/
exports.announcement_edit = function(req, res) {
	if (req.params.key) {
		res.render('index', { title: 'Edit announcement', feedbacks: { errors: [], messages: [] }, 
								formUrl: '/announcements/edit-form/' + req.params.key
							}); 	
	} else {
		failedAnnouncement(req, res, ["Cannot find announcement to edit"]); 
	}
}; 


/**
* Posts the data to edit an announcement
*/

exports.announcement_edit_form = function(req, res) {
	if (req.params.key) {
		firebase.postRef.once('value').then(snapshot => {
			if(snapshot.val()) {
				var requestedEvent;
				var announcementListEntries = Object.entries(snapshot.val()); 
				var announcementMap = new Map([]); 

				announcementListEntries.forEach(entry => {
					announcementMap.set(entry[0], entry[1]); 
				});

				var requestedAnnouncement = announcementMap.get(req.params.key); 
				var templateObjects;
				firebase.templateRef.once('value').then(snapshot =>{
					if(snapshot.val()){
						var templateEntries = Object.entries(snapshot.val()); 
						templateObjects =templateEntries.map(function(entry) {
							return {
								firebaseKey: entry[0],
								name: entry[1].name,
								content: entry[1].content,
							}; 
						}); 
					}
				});
				firebase.eventRef.once('value').then(snapshot => {
					if(snapshot.val()){
						var eventListEntries = Object.entries(snapshot.val());
						var eventMap = new Map([]);
						eventListEntries.forEach(entry=>{
							eventMap.set(entry[0], entry[1]);
						});
						requestedEvent = eventMap.get(req.params.key);



						if (!requestedAnnouncement) {
							failedAnnouncement(req, res, ['Cannot retrieve announcement from firebase']); 
							return; 
						}
						if(requestedEvent){
							res.render('form', {  title: 'Announcement form', feedbacks: { errors: [],
												 messages: [] },
								 key: req.params.key,
								 template: templateObjects,
								 requestTitle: requestedAnnouncement.title,
								 requestContent: requestedAnnouncement.content,
								 requestTopic: requestedAnnouncement.topic,
								 requestDesc: requestedEvent.desc,
								 requestDay: requestedEvent.day,
								 requestEnd: requestedEvent.endtime,
								 requestlocation: requestedEvent.location,
								 requestStart: requestedEvent.starttime,
								 requestEventTitle: requestedEvent.title, }); 

						}else{
							res.render('form', {  title: 'Announcement form', feedbacks: { errors: [],
												 messages: [] },
								 key: req.params.key,
								 template: templateObjects,
								 requestTitle: requestedAnnouncement.title,
								 requestContent: requestedAnnouncement.content,
								 requestTopic: requestedAnnouncement.topic,
								  }); 

						}
					}else{
						res.render('form', {  title: 'Announcement form', feedbacks: { errors: [],
											 messages: [] },
							 key: req.params.key,
							 template: templateObjects,
							 requestTitle: requestedAnnouncement.title,
							 requestContent: requestedAnnouncement.content,
							 requestTopic: requestedAnnouncement.topic,
								  }); 
					}
					
				});

			} else {
				failedAnnouncement(req, res, ['Cannot retrieve announcement from firebase']); 
			}
		}); 
	} else {
		failedAnnouncement(req, res, ["Cannot find announcement to edit"]); 
	}
}; 

/** 
 * Processes announcement data posted for submission to firebase. 
 */ 
exports.announce_post = [

	body('title', 'Please give title to the announcement').isLength({min: 1}).trim(), 
	body('content', 'Please add content to announcement').isLength({min: 1}).trim(),

	body('eventtitle', 'Event must have a title').isLength({min: 1}), 
	body('desc', 'Event must have a description').isLength({min: 1}),
	body('date', 'Event must have a date').isLength({min: 1}), 
	body('stime', 'Event must have a start time').isLength({min: 1}), 
	body('etime', 'Event must have an end time').isLength({min: 1}), 
	body('loc', 'Event must have a location').isLength({min: 1}), 

	// Trim (remove spaces), and escape (escape all html)
	sanitizeBody('name').trim().escape(), 
	sanitizeBody('title').trim().escape(), 

	// Now process the request after validation, and sanitization
	(req, res, next) => {

		var allErrors = validationResult(req).array().map(errorObject => errorObject.msg);
		var intendedEvent = req.body.eventOrNot.startsWith('Add'); 
		var canSendAnnouncement = true;
 
		if (!intendedEvent) allErrors = allErrors.filter(error => error.startsWith('Please')); 
		allErrors.forEach(error => {
			if (error.startsWith('Please')) canSendAnnouncement = false; 
		})

		if(canSendAnnouncement) { 
			
			// HERE: initialise the actual announcement
			var announcement = {
				title: req.body.title,
				content: req.body.content,
				hasEvent: false,
				tag: req.body.tag,
				pdf: req.body.pdfEncoding,
				readingList: ["none"],
				photoB64: ''
			}

			stampAnnouncement(req, announcement);
			
			// NOTE: it's okay to not provide a filter-file, but not so to have empty email list in the file
			if (allErrors.length == 0) {
				if (intendedEvent) {
					firebase.newEvent(req.body.eventtitle, req.body.desc, req.body.date, req.body.stime, req.body.etime, req.body.loc, announcement.firebaseKey)
					.then(sentSuccessfully => {
						announcement.hasEvent = true; 
						addMailingListAndSend(req, res, announcement);  
					})
					.catch(reject => failedAnnouncement(req, res, 
						['Couldn\'t send event to Firebase, please check your connection'])); 
				} else {
					addMailingListAndSend(req, res, announcement);  
				}
			} else {
				failedAnnouncement(req, res, allErrors);
			}
		} else {
			failedAnnouncement(req, res, allErrors);
		}
	}
]; 

/** 
 * Displays a neutral fresh announcement form 
 */ 
exports.announcement_form = function(req, res) {

	firebase.templateRef.once('value').then(function(snapshot) {
		if (snapshot.val()) {
			
			var templateEntries = Object.entries(snapshot.val()); 
			var templateObjects =templateEntries.map(function(entry) {
				return {
					firebaseKey: entry[0],
					name: entry[1].name,
					content: entry[1].content,
				}; 
			}); 

			var errorMessage; 
			if (req.params.errorCode == 0) {
				errorMessage = 'You are not authorised to remove admins from list!'; 
			} else if (req.params.errorCode == 1) {
				errorMessage = 'You are not authorised to add admins to the list!';
			} 

			var status = errorMessage ? 400 : 200; 
			res.status(status).render('form', { title: 'Announcement Form', 
									template: templateObjects, 
									error: errorMessage,
									feedbacks: { errors: [], messages: [] }});
		}else{
			res.status(status).render('form', { title: 'Announcement Form',  feedbacks: { errors: [], messages: [] } });  
		}
	}).catch(err => console.log(err));
}; 

/** 
 * Display form with select-options for target programme, status, and year. 
 * @req Request containing a file 
 * @res Response to render the resulting form
 */ 
exports.groupStudents = function(req, res) {

	if (!fileFormatSupported(req, res)) return; 

	var date = dateTime.create(); 
 	var formattedDate = date.format('YmdHMS'); 
	var requestFile = req.file; 

	var tmp_path = requestFile.path;
	var target_path = process.cwd().split('\\').join('/') + '/uploads/' + requestFile.originalname.replace('.xlsx', '').split(' ').join('_') + formattedDate + '.xlsx';

	fs.rename(tmp_path, target_path, err => {
		if (err) failedAnnouncement(req, res, ['Error handling the filter-file']);  
		req.session.filterFileUrl = target_path; 
		var fileTableHeaders = xlsxParser.createFilterFileData(target_path); 
		
		if (fileTableHeaders && Object.entries(fileTableHeaders).length > 0) {
			req.session.columnLabelMap = fileTableHeaders.columnLabelMap; 
			req.session.worksheet = fileTableHeaders.worksheet; 

			res.render('form', { title: 'New announcement filtered', 
						 feedbacks: { 
						 	errors: [],
						 	messages: []
						 }, 
						 key: req.body.key,
						 requestTitle: req.body.title,
						 requestContent: req.body.content, 
						 requestTopic: req.body.topic,
						 filterFileUrl: target_path,
						 programmesArray: xlsxParser.getColumnValueSet(fileTableHeaders.worksheet, fileTableHeaders.columnLabelMap, 'programme'), 
						 statusArray: xlsxParser.getColumnValueSet(fileTableHeaders.worksheet, fileTableHeaders.columnLabelMap, 'status'),  
						 yearsArray: xlsxParser.getColumnValueSet(fileTableHeaders.worksheet, fileTableHeaders.columnLabelMap, 'year')}); 
		} else {
			failedAnnouncement(req, res, ['No filter-file detected with the following columns: "programme", "username", "status", and "year"']); 
		}
	}); 

}

/** 
 * Sends a given announcement to firebase, and responds with 
 *  the announcement form with success-message 
 */ 
function successfulAnnouncement(req, res, announcement) {
	firebase.sendAnnouncement(announcement.firebaseKey, announcement)
	.then(sentSuccessfully => { 
	
			firebase.templateRef.once('value').then(function(snapshot) {
				if (snapshot.val()) {
					
					var templateEntries = Object.entries(snapshot.val()); 
					var templateObjects = templateEntries.map(function(entry) {
						return {
							firebaseKey: entry[0],
							name: entry[1].name,
							content: entry[1].content,
						}; 
					}); 

					res.render('form', { title: 'Announcement Form', 
											template: templateObjects, 
											feedbacks: { errors: [], messages: ['Sent successfully'] }});
				}else{
					res.render('form', { title: 'Announcement Form',  feedbacks: { errors: [], messages: [], template: [] } });  
				}
			}).catch(err => console.log(err));
		
	})
	.catch(reject => failedAnnouncement(req, res,
		['Couldn\'t send announcement to firebase, please check your connection'])); 
}

/** 
 * Takes an incomplete request, responds with status 400 BAD REQUEST, 
 * and re-displays the announcement form with the given allErrors. 
 */ 
function failedAnnouncement(req, res, allErrors) {
	
	debug('Error(s) in creating a post'); 			
		res.status(400) // bad request; 
		firebase.templateRef.once('value').then(function(snapshot) {
		if (snapshot.val()) {
			
			var templateEntries = Object.entries(snapshot.val()); 
			var templateObjects =templateEntries.map(function(entry) {
				return {
					firebaseKey: entry[0],
					name: entry[1].name,
					content: entry[1].content,
				}; 
			}); 

			res.render('form', { title: 'Announcement Form', 
									template: templateObjects, 
									feedbacks: { errors: allErrors, messages: [] },
									requestTitle: req.body.title,
									requestContent: req.body.content
								});
		} else {
			res.render('form', { title: 'Announcement Form',  
								feedbacks: { errors: allErrors, messages: [] },
								requestTitle: req.body.title,
								requestContent: req.body.content });  
		}
	}).catch(err => console.log(err)); 

}

/** 
 * Takes a request with a file, parses the students' email list 
 * and adds it as the mailingList attribute of the given announcement 
 */ 
function addMailingListAndSend(req, res, announcement) {

		switch (req.body.targetGroup) {
		case 'All students': 
			announcement.mailingList = ['all'];
			break; 
		case 'By k-number': 
			var knumbers = req.body.mailingList; 
			if (knumbers) {
				announcement.mailingList = knumbers.split(','); 
			} else {
				failedAnnouncement(req, res, ['Please provide at least one k-number, or target group in a different way']); 
				return; 
			}	
			break; 
		default: 
			var targetProgrammes = req.body.targetProgrammes; 
			var targetStatuses = req.body.targetStatuses; 
			var targetYears = req.body.targetYears;

			if (!targetProgrammes && !targetStatuses && 
					!targetYears) {
				failedAnnouncement(req, res, ['Please choose at least one target option, or target group in a different way'])
				return; 
			} else {
				announcement.mailingList = 
				xlsxParser.createMailingList(req.session.worksheet, req.session.columnLabelMap, targetProgrammes, targetStatuses,
										targetYears); 
			
				if (!announcement.mailingList || announcement.mailingList.length == 0) {
					failedAnnouncement(req, res, ['There were no students for the chosen criteria in your file. Please check your file']); 
					return; 	
				}
				// as soon as the announcement is made, you delete the filter-file
				if (req.session.filterFileUrl) {
					fs.unlink(req.session.filterFileUrl, error => console.log(error)); 
					delete req.session.filterFileUrl; 
				}
			}
			break; 
		}
		
		successfulAnnouncement(req, res, announcement);
}

/** 
 * Checks whether a file uploaded in the request is an .xlsx file. 
 * If not, renders failure messsage in response. 
 */ 
function fileFormatSupported(req, res) {
	if (req.file.originalname.endsWith('.xlsx')) {
		return true; 
	} else {
		failedAnnouncement(req, res, ['Filter file must be in .xlsx format'])
		return false; 
	}
}

/** 
 * Adds the extra, and optional attributes of announcement
 */ 
function stampAnnouncement(req, announcement) {
	var date = dateTime.create(); 
	var formattedDate = date.format('Y-m-d H:M:S'); 
	var customKey = date.format('Y-m-d-H:M:S') + '-' + 
   		Math.floor(Math.random() * 1000); 

	announcement.dateTime = formattedDate; 
	announcement.priority = (new Date(0) - new Date()); 
	announcement.firebaseKey = customKey; 
	process.env.testWithoutAccessCheck ? announcement.author = 'auto-test' : 
				announcement.author = req.session.adminEmail; 
	if (req.session.photoB64) announcement.photoB64 = req.session.photoB64; 
	if (req.body.key) announcement.firebaseKey = req.body.key; 
}
