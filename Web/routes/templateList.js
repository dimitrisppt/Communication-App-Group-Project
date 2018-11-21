var express = require('express');
var fs = require('fs'); 
var router = express.Router();

var listTemplate = require('../controllers/listTemplateController'); 

// Loads functions handling GET requests of pages displaying all templates and displaying details of specific template
router.get('/', listTemplate.template_get);
router.get('/detail/:key', listTemplate.template_detail);
router.get('/templateListForm/:key', listTemplate.template_form)
router.get('/delete/:key', listTemplate.template_delete);



module.exports = router;