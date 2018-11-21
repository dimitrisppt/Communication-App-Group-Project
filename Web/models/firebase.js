var https = require('https');
var fs = require('fs');
var google = require('googleapis');
var PROJECT_ID = 'spiderbyte-a653e';
var HOST = 'fcm.googleapis.com';
var PATH = '/v1/projects/' + PROJECT_ID + '/messages:send';
var MESSAGING_SCOPE = 'https://www.googleapis.com/auth/firebase.messaging';
var SCOPES = [MESSAGING_SCOPE];
var firebase = require('firebase-admin');
var dateTime = require('node-datetime'); 
var Promise = require('promise');

/**
 * Get a valid access token.
 */
var getAccessToken = function() {
  return new Promise(function(resolve, reject) {
    var key = require('./service-account.json');
    var jwtClient = new google.auth.JWT(
      key.client_email,
      null,
      key.private_key,
      SCOPES,
      null
    );
    jwtClient.authorize(function(err, tokens) {
      if (err) {
        reject(err);
        return;
      }
      resolve(tokens.access_token);
    });
  });
}

/**
 * Send HTTP request to FCM with given message.
 *
 * @param {JSON} fcmMessage will make up the body of the request.
 */
var sendFcmMessage = function(fcmMessage) {
    
  return new Promise(function(resolve, reject) {
    getAccessToken().then(function(accessToken) {
      var options = {
        hostname: HOST,
        path: PATH,
        method: 'POST',
        headers: {
          'Authorization': 'Bearer ' + accessToken
        }
      };

      var request = https.request(options, function(res) {
        res.setEncoding('utf8');
        res.on('data', function(data) {
          console.log('Message sent to Firebase for delivery, response:');
          console.log(data);

          resolve(true); 
        });
      });

      request.on('error', function(err) {
        console.log('Unable to send message to Firebase');
        console.log(err); 
        reject(false); 
      });

      request.write(JSON.stringify(fcmMessage));
      request.end();

    });

   setTimeout(function() {
      reject(false); 
    }, 5000); 

  })

}

/**
 * Construct a JSON object that will be used to define the
 * common parts of a notification message that will be sent
 * to any app instance subscribed to the news topic.
 * @param {String} shortMessage  short message that will be building our notification
 */
var buildCommonMessage = function(shortMessage) {
  return {
    'message': {
      'topic': 'news',
      'android': {
        'priority': 'high',
        'notification': {
          'title': 'Spider-Byte',
          'body': shortMessage,
          'sound': "default"
        },
        'data': {
          'MessageContent': shortMessage
        }
      }
    }
  };
}

/*
* Builds the Notification
* @param {String} shortMessage Will form the content of our notification
*/
var sendNotification = function(shortMessage) {
  return sendFcmMessage(buildCommonMessage(shortMessage));
}


//Initialisation of our firebase app with our credentials

var serviceAccount = require('./service-account.json');
firebase.initializeApp({
  credential: firebase.credential.cert(serviceAccount),
  databaseURL: 'https://spiderbyte-a653e.firebaseio.com'
});


//Variables that refer to the database
var db = firebase.database();
var ref = db.ref("/");
var refAdmins = db.ref('admins');
var postRef = ref.child("announcements");
var templateRef = ref.child("templates");
var AndroidUsersRef = ref.child("app-users").child("Android");
var IosUsersRef = ref.child("app-users").child("iOS");
var usersRef = ref.child("admins");
var eventRef = ref.child("event");


/*
* Can create a new template and add it to the database table or edit an existing template
* @param {String} customKey Our customed key for the templates
* @param {Object} template the template itself that will be set in the adequate table
*/
var newTemplate = function(customKey, template){
  delete template.firebaseKey; 

  if(template.key) {
    ref.child("templates").child(template.key)
      .set(template); 
  } else {
    templateRef.push({
      name: template.name,
      content: template.content
    })
  }
}


/*
* Can create a new announcement and add it to the database table or edit an existing announcement
* @param {String} customKey Our customed key for the announcements
* @param {Object} announcement the announcement itself that will be set in the adequate table
*/
var sendAnnouncement = function(customKey, announcement) {

  announcement.content = announcement.content.replace(/\r/g, '  \r');
  delete announcement.firebaseKey; 

  if(announcement.key) {
    ref.child("announcements").child(announcement.key)
      .set(announcement); 
  } else {
    ref.child("announcements").child(customKey).set(announcement);
  }

  return sendNotification(announcement.title); 

}
 
/*
* Can create a new admin and add it to the database table
* @param {String} name the name of the admin
* @param {Object} email the email of the admin
*/
var newAdmin = function(name, email) {
  usersRef.push({
    name: name,
    email: email,
  });
}


/*
* Deletes a precise admin
* @param {String} key the key of the admin to delete
*/
var deleteAdmin = function(key) {
  console.log("Deleting admin"); 
  return usersRef.child(key).remove(); 
}

/*
* Deletes a precise template
* @param {String} key the key of the template to delete
*/
var deleteTemplate = function(key) {
  console.log("Deleting template"); 
  return templateRef.child(key).remove(); 
}

/*
* Deletes the last event
*/
var deleteLastAdmin = function() {
  return refAdmins.once('value').then(function(snapshot) {
    if (snapshot.val()) {
      var adminKeys = Object.keys(snapshot.val()); 
      return deleteAdmin(adminKeys[adminKeys.length - 1]); 
    } else {
      console.log("failed reading admins from firebase")
    }
  }).catch(err => console.log(err)); 
}

/*
* Deletes a precise Announcement
* @param {String} key the key of the Announcement to delete
*/
var deleteAnnouncement = function(key) {
  console.log('deleting!'); 
  postRef.child(key).remove(); 
}


/*
* Deletes a precise Event
* @param {String} key the key of the event to delete
*/
var deleteEvent = function(key) {
  console.log('deleting!'); 
  eventRef.child(key).remove(); 
}

/*
* Deletes the last event
*/
var deleteLastEvent = function() {
  return eventRef.once('value').then(function(snapshot) {
    if (snapshot.val()) {
      var eventKeys = Object.keys(snapshot.val()); 
      deleteEvent(eventKeys[eventKeys.length - 1]); 
    } else {
      console.log("failed reading events from firebase")
    }
  }).catch(err => console.log(err)); 
}

/*
* Deletes the last event
*/
var deleteLastAnnouncement = function() {
  return postRef.once('value').then(function(snapshot) {
    if (snapshot.val()) {
      var announcementKeys = Object.keys(snapshot.val()); 
      deleteAnnouncement(anouncementKeys[announcementKeys.length - 1]); 
    } else {
      console.log("failed reading announcement from firebase")
    }
  }).catch(err => console.log(err)); 
}



/*
* Can create a new event and add it to the database table
* @param {String} title the title of the event
* @param {String} description the description of the event
* @param {String} day the day the event will occur on
* @param {String} starttime the start time of the event
* @param {String} endtime the end time of the event
* @param {String} location the location of the event
* @param {String} announcementKey refers to the key of the announcement to be able to link them
*/
var newEvent = function(title, description, day, starttime, endtime, location, announcementKey) {

  var priority = (new Date(0) - new Date(day + " " + starttime)); 
  eventRef.child(announcementKey).set({
    title: title,
    desc: description,
    day: day,
    starttime: starttime,
    endtime: endtime,
    priority: priority,
    location: location,
    mailingList: ["all"]
  });
  return sendNotification(title); 

}

module.exports = { deleteLastAnnouncement, deleteLastAdmin, AndroidUsersRef , IosUsersRef , deleteTemplate , newTemplate , templateRef, refAdmins, deleteAdmin, deleteEvent, newAdmin, postRef, deleteAnnouncement, sendAnnouncement, eventRef , ref, getAccessToken , newEvent};

