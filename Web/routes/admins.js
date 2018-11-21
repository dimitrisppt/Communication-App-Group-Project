var express = require('express');
var router = express.Router();

var adminController = require('../controllers/adminController'); 

// Loads functions handling GET requests of pages for displaying all admins
// Loads functions handling POST requests to post a new admin
router.get('/', adminController.admins_get);
router.get('/error/:errorCode/', adminController.admins_get); 
router.get('/new/', adminController.admin_new_get); 
router.post('/new/', adminController.admin_new_post); 
router.get('/delete/:key/', adminController.admin_delete); 

module.exports = router;
