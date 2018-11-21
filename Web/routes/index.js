var express = require('express');
var router = express.Router();
var accessController = require('../controllers/accessController'); 

// Loads functions handling GET requests of pages for logging in, authenticating, denying access and logging out
router.get('/', accessController.renderHome);
router.get('/login-first', accessController.renderLogin); 
router.get('/login', accessController.login);
router.get('/token', accessController.getToken);
router.get('/logout', accessController.logout);
router.get('/access-denied', accessController.denyAccess); 
router.get('/copyright', accessController.get_Copyright);

module.exports = router;
