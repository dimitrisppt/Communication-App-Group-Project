var express = require('express');
var router = express.Router();

var templateController = require('../controllers/templateController'); 

// Loads functions handling GET requests of pages for creating new templates
// Loads functions handling POST requests to post a new template
router.get('/', templateController.template_new_get); 
router.post('/', templateController.template_new_post); 
router.get('/templateForm/', templateController.template_form);
router.get('/edit/:key', templateController.template_edit)
router.get('/edit-form/:key', templateController.template_edit_form); 

module.exports = router;
