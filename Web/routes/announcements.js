
var express = require('express'); 
var router = express.Router(); 

// multi-part form handling 
var multer = require('multer'); 
var upload = multer({ dest: 'uploads/' }); 

// Require the controller modules 
var announcement_controller = require('../controllers/announcementController'); 


// Loads functions handling GET requests of pages for creating and editing announcements
// Loads functions handling POST requests to post and edit an announcement
router.get('/create/', announcement_controller.announce_get); 
router.get('/edit/:key', announcement_controller.announcement_edit)
router.get('/edit-form/:key', announcement_controller.announcement_edit_form); 
router.post('/create/', upload.single('filter-file'), announcement_controller.announce_post); 
router.get('/form/', announcement_controller.announcement_form);	
router.post('/groupStudents/', upload.single('filter-file'), announcement_controller.groupStudents); 
router.get('/form-knumber/', announcement_controller.announcement_form); 

module.exports = router; 