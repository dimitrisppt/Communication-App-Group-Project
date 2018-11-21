//variables needed
var express = require('express');
var path = require('path');
var favicon = require('serve-favicon');
var logger = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var compression = require('compression'); // for production - faster delivery 
var helmet = require('helmet'); 		// for production - security against common web vulnerabilities 
var passport = require('passport'); 
var OIDCStrategy = require('passport-azure-ad').OIDCStrategy;
var uuid = require('uuid');
var config = require('./utils/config.js');
var session = require('express-session');
var index = require('./routes/index');
var admins = require('./routes/admins');
var listAnnouncements = require('./routes/listAnnouncements');
var announcements = require('./routes/announcements'); 
var event = require('./routes/event');
var templates = require('./routes/templates')
var listTemplate = require('./routes/templateList')
var app = express();

// authentication setup
var callback = (iss, sub, profile, accessToken, refreshToken, done) => {
  done(null, {
    profile,
    accessToken,
    refreshToken
  });
};

passport.use(new OIDCStrategy(config.creds, callback));

var users = {};
passport.serializeUser((user, done) => {
  var id = uuid.v4();
  users[id] = user;
  done(null, id);
});
passport.deserializeUser((id, done) => {
  var user = users[id];
  done(null, user);
});

app.use(helmet()); 
app.use(bodyParser({limit: '50mb'}));

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');

//loads resources 
app.use(favicon(__dirname + '/public/spider.png'));
app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(cookieParser());

app.use(compression()); // compress all routes for faster delivery 
app.use(express.static(path.join(__dirname, 'public')));

app.use(session({
  secret: '12345QWERTY-SECRET',
  name: 'graphNodeCookie',
  resave: false,
  saveUninitialized: false
}));

app.use(passport.initialize());
app.use(passport.session()); 

app.use(function(req, res, next) {
  res.locals.session = req.session; 
  next(); 
})

//Setup of the routes
app.use(authorisationCheck); 
app.use('/', index);
app.use('/admins', admins);
app.use('/listAnnouncements', listAnnouncements);
app.use('/announcements', announcements); 
app.use('/event', event);
app.use('/templates', templates); 
app.use('/templateList', listTemplate);
app.use('/', express.static(path.join(__dirname, 'public'))); 


// catch 404 and forward to error handler
app.use(function(req, res, next) {
  var err = new Error('Not Found');
  err.status = 404;
  next(err); 
});

// error handler
app.use(function(err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render('error');
});

/**
 * Denies access to a page if a user is not logged in
 * Authentication is not requires to query PDF files 
 */
function authorisationCheck(req, res, next) {

  if(req.path.startsWith("/listAnnouncements/pdf")) return next();

  if (!process.env.testWithoutAccessCheck) {

    if (req.session.adminName || req.path === '/access-denied'
           || req.path === '/login' || req.path === '/token' || 
            req.path === '/login-first') {
      console.log(req.session); 
      next(); 
    } else {
      res.redirect('/login-first'); 
    }

  } else {
    next(); 
  }
}

module.exports = app;