var graphHelper = require('../utils/graphHelper.js');
var passport = require('passport');
var firebase = require('../models/firebase');
var https = require('https'); 
var fs = require('fs'); 

/**
 * Attempts to authenticate a user and redirect to login page 
 */
exports.login = [
  passport.authenticate('azuread-openidconnect', { failureRedirect: '/' }),
  (req, res) => {
     res.redirect('/');
  }
]; 

/**
 * Autenthicate a user with Microsoft Outlook then authenticate with firebase admin database
 * Redirect to home page if succesful and to login page otherwise
 * And creates super admins
 */
exports.getToken = [

  passport.authenticate('azuread-openidconnect', { failureRedirect: '/' }),
    (req, res) => {

      graphHelper.getUserData(req.user.accessToken, (err, user) => {

        if (!err) {
          req.user.profile.displayName = user.body.displayName;
          req.user.profile.emails = [{ address: user.body.mail || user.body.userPrincipalName }];

          // -- Section: apply adminList filter to users logging in, secondary security check
          firebase.refAdmins.once('value').then(function(snapshot) {
            if (snapshot.val()) {
              var adminEmailList = Object.values(snapshot.val())
                                    .map(adminObject => adminObject.email); 
        
              var adminEmailLoggingIn = user.body.mail || user.body.userPrincipalName;  
              var findsAdminEmail = adminEmailList.includes(adminEmailLoggingIn); 

              if (findsAdminEmail) {
                req.session.adminName = req.user.profile.displayName || "Default username"; // default username is for tester accounts  
                req.session.adminEmail = adminEmailLoggingIn; 
  
                graphHelper.getProfilePhoto(req.user.accessToken, function(err, photo) {
                  if (photo.error) return; 
                  req.session.photoB64 = photo.toString('base64'); 
                  fs.writeFile('public/' + adminEmailLoggingIn + '.jpg', photo, 'binary', err => console.log(err)); 
                })

                req.session.homePageCount = 0;
                if (adminEmailLoggingIn === "munkhtulga.battogtokh@kcl.ac.uk"
                   || adminEmailLoggingIn === "henry.valeyre@kcl.ac.uk"
                   || adminEmailLoggingIn === "spider-byte-tester@outlook.com") {
                  req.session.isSuperAdmin = true; 
                  renderHome(req, res); 
                } else {
                  renderHome(req, res);
                }
                
              } else {
                var email = req.session.adminEmail; 
                req.session.destroy(() => {
                  fs.unlink('public/' + email + '.jpg', error => console.log('Did not find profile photo to delete')); 
                  req.logout();
                  res.redirect('https://login.microsoftonline.com/fabrikamb2c.onmicrosoft.com/oauth2/v2.0/logout?p=b2c_1_sign_in&post_logout_redirect_uri=http://localhost:3000/access-denied');
                });
              }              
            } else {
              res.render('login', { title: 'Log in to SpiderByte', message: 'Cannot retrieve admin data from firebase' }); 
            }
          // -- Section end 
          }).catch(err => console.log(err)); 

        } else {
          renderError(err, res);
        }
      });
    }
]; 

/**
 * Redirects to login page as the login was denied
 */
exports.denyAccess = function(req, res) {
  res.render('login', { title: 'Log in to SpiderByte', message: 'You are not authorised to be here'}); 
}

exports.logout = function(req, res) {
  var email = req.session.adminEmail; 
  req.session.destroy(() => {
    fs.unlink('public/' + email + '.jpg', error => console.log('Did not find profile photo to delete')); 
    req.logout();
    res.redirect('https://login.microsoftonline.com/fabrikamb2c.onmicrosoft.com/oauth2/v2.0/logout?p=b2c_1_sign_in&post_logout_redirect_uri=http://localhost:3000'); 
  });
}

/**
 * Displays login page
 */
exports.renderLogin = function(req, res) {
  res.render('login', { title: 'Log in to SpiderByte'}); 
}


/**
 * Displays License for our copyright
 */
exports.get_Copyright = function(req, res) {
  res.render('copyright', { title: 'Copyright for SpiderByte'}); 
}


/**
 * Loads statistics and renders the home page displaying those
 */
var renderHome = function(req, res) {

  var preload = false;  
  if (!process.env.PASSWORD) {
    if (req.session.homePageCount == 0) preload = true; 
  } 

  req.session.homePageCount++; 
  var stats = {}; 

  firebase.ref.child('announcements').once('value').then(snapshot => {
    
    if(snapshot.val()) {
      var entries = Object.entries(snapshot.val()); 
      stats.announcementCount = entries.length; 
      stats.latestAnnouncement = entries[entries.length - 1][1]; 
      stats.latestAnnouncement.key = entries[entries.length - 1][0]; 
      stats.oldestAnnouncement = entries[0][1]; 
      stats.oldestAnnouncement.key = entries[0][0]; 

      firebase.ref.child('admins').once('value').then(snapshot => {
        
        if(snapshot.val()) {
          var entries = Object.entries(snapshot.val()); 
          stats.adminCount = entries.length; 
          
          firebase.ref.child('event').once('value').then(snapshot => {
            if(snapshot.val()) {
              var entries = Object.entries(snapshot.val()); 
              stats.eventCount = entries.length; 
              stats.latestEvent = entries[entries.length - 1][1]; 
              stats.oldestEvent = entries[0][1]; 
              
              firebase.ref.child('app-users').once('value').then(snapshot => {
            if(snapshot.val()) {
              var entries = Object.entries(snapshot.val()); 
              stats.androidCount = entries[0][1].length
              stats.iosCount = entries[1][1].length
              
              res.render('home', {
                title: 'Dashboard', 
                display_name: req.session.adminName, 
                email_address: req.session.adminEmail,
                preload: preload,
                stats: stats
              });
            } else {
              res.render('home', {
                title: 'Dashboard', 
                display_name: req.session.adminName, 
                email_address: req.session.adminEmail,
                preload: preload
              });
            }
          }) 
            }
          }) 
        }
      }); 
    }
  });  

}
/**
 * Load the announcements page
 */
function renderAnnouncement(req, res) {
  res.render('index', {
    title: 'New announcement', 
    display_name: req.session.adminName, 
    email_address: req.session.adminEmail
  });
}

/**
 * Checks if the user is still authenticated
 * @param {Object} e  expiration of the token
 */
function hasAccessTokenExpired(e) {
  let expired;
  if (!e.innerError) {
    expired = false;
  } else {
    expired = e.forbidden &&
      e.message === 'InvalidAuthenticationToken' &&
      e.response.error.message === 'Access token has expired.';
  }
  return expired;
}
/**
 * Displays the error page
 * @param {*} e 
 * @param {*} res 
 */
function renderError(e, res) {
  e.innerError = (e.response) ? e.response.text : '';
  res.render('error', {
    error: e
  });
}

module.exports.renderHome = renderHome;
