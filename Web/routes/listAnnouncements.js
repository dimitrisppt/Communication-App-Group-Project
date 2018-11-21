var express = require('express');
var fs = require('fs'); 
var router = express.Router();

var listAnnouncements = require('../controllers/listAnnouncementsController'); 

// Loads functions handling GET requests of pages displaying all announcement, opening pdf attachments, displaying details of specific announcement
router.get('/', listAnnouncements.announcement_get); 
router.get('/detail/:key', listAnnouncements.announcement_detail); 
router.get('/delete/:key', listAnnouncements.announcement_delete);
router.get('/viewAnnouncementForm/:key', listAnnouncements.announcement_form)
router.get('/pdf.pdf', listAnnouncements.show_pdf);
router.get('/pdf/:key.pdf', listAnnouncements.get_pdf);


module.exports = router;