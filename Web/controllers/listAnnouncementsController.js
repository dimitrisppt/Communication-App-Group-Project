var fs = require('fs'); 
var { body, validationResult } = require('express-validator/check'); 
var { sanitizeBody } = require('express-validator/filter'); 
var debug = require('debug'); 
var firebase = require('../models/firebase'); 

/**
* Obtains data on all announcements and displays the page listing all announcements
*/
exports.announcement_get = function(req, res) {
	firebase.postRef.once('value').then(function(snapshot) {
		if (snapshot.val()) {
			var announcementListEntries = Object.entries(snapshot.val()); 
			var announcementObjects =announcementListEntries.map(function(entry) {
				return {
					firebaseKey: entry[0],
					author: entry[1].author,
      				title: entry[1].title,
      				date: entry[1].dateTime,
      				views: entry[1].readingList.length
				}; 
			}); 

			var errorMessage; 
			if (req.params.errorCode == 0) {
				errorMessage = 'You are not authorised to remove admins from list!'; 
			} else if (req.params.errorCode == 1) {
				errorMessage = 'You are not authorised to add admins to the list!';
			} 

			var status = errorMessage ? 400 : 200; 
			res.status(status).render('listOfAnnouncements', { announcementList: announcementObjects, 
									error: errorMessage
									} ); 
		} else {
			res.render('listOfAnnouncements', { announcementList: [] }); 
		}
	}).catch(err => console.log(err)); 
	
}; 

/**
* Renders the form showing details about an announcement and writes any existing pdf attachment
*/
exports.announcement_form = function(req,res){
	

	firebase.postRef.child(req.params.key).once('value').then(snapshot => {
		
		var announcementToShow = snapshot.val(); 
		if (announcementToShow) {

			announcementToShow.readingList = "Views : " + announcementToShow.readingList.length
			if(announcementToShow.pdf) {
				var bitmap = new Buffer(announcementToShow.pdf.substr(28), 'base64');
				// write buffer to file
				fs.writeFileSync("preview.pdf", bitmap);
			}
		
			res.render('viewAnnouncementForm', { title: 'Announcement detail', 
				announcement: announcementToShow
			})
		}	
	})
}

/**
* Displays the page containing the form with all information about a specific announcement
*/
exports.announcement_detail = function(req, res) {
		
	res.render('viewAnnouncement', { title: 'Announcement detail', 
							  announcementKey: req.params.key
	})
}

/**
* Deletes a specific announcement
*/
exports.announcement_delete = function(req, res) {
	firebase.deleteAnnouncement(req.params.key)
	res.status(200).redirect('/listAnnouncements') 
}

/**
* Upload the pdf attachment to a page
*/
exports.show_pdf = function(req, res) {
  pdf(req, res);
}

/**
* Function used to upload a pdf attachment to a page
*/
function pdf(req, res){

	var stream = fs.createReadStream('preview.pdf');
	var filename = "Preview.pdf"; 

	filename = encodeURIComponent(filename);

	res.setHeader('Content-disposition', 'inline; filename="' + filename + '"');
	res.setHeader('Content-type', 'application/pdf');

	stream.pipe(res);

}

/**
 * Writes the pdf attachment for a queried announcement and uploads it to a page 
 */
exports.get_pdf = function(req, res){

		firebase.postRef.once('value').then(function(snapshot) {
			if (snapshot.val()) {
				var announcementListEntries = Object.entries(snapshot.val()); 
				var announcementMap = new Map([]); 
				var announcementObjects = announcementListEntries.forEach(function(entry) {
					var firebaseKey = entry[0];
						announcementMap.set(firebaseKey, {
		      				pdf: entry[1].pdf
						})
			}); 

			var announcementToShow = announcementMap.get(req.params.key);

			if(announcementToShow.pdf){

				var bitmap = new Buffer(announcementToShow.pdf.substr(28), 'base64');
						    // write buffer to file
				fs.writeFileSync("preview.pdf", bitmap);
				pdf(req, res);
			}			
		}
	}).catch(err => console.log(err));

}

