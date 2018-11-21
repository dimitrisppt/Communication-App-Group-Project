var express = require('express');
var router = express.Router();

var event = require('../controllers/eventController'); 

// Loads functions handling GET requests of pages for showing all events and deleting a specific event
router.get('/', event.event_get); 
router.get('/delete/:key', event.event_delete); 


module.exports = router;