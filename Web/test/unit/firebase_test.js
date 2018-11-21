var chai = require('chai').use(require('chai-as-promised')); 
var chaiHttp = require('chai-http'); 
var expect = chai.expect; 
var fail = expect.fail; 

chai.use(chaiHttp); 

var firebase = require('../../models/firebase'); 

var http = require('http'); 

describe('Firebase tests', function() {

	it('should have internet', function(done) {
		http.get('http://www.munkhtulga.com', function() {

			describe('Firebase module', function() {
				this.slow(500);

				it('should return a string with getAccessToken() given proper connections', function(done) {

					firebase.getAccessToken()
					.then(accesToken => {
						expect(accesToken).to.be.a('string'); 
						done(); 
					})
					.catch(done)
				
				}); 

				it('should create a new announcement entry on firebase, when sendAnnouncement is called', function(done) {
					
					var announcement = {
						author: 'firebase_test.js',
						title: 'Auto test',
						content: 'Testing sendAnnouncement method of firebase module', 
						mailingList: [] 
					}; 

					firebase.sendAnnouncement('testAnnouncement', announcement); 
					firebase.postRef.child('testAnnouncement').once('value').then(function(snapshot) {
						var newPost = snapshot.val();  

						expect(newPost.title).to.equal(announcement.title); 
						expect(newPost.content).to.equal(announcement.content); 
						firebase.deleteAnnouncement('testAnnouncement'); 
						done(); 
					}); 
				}); 

				it('should not change admins count on firebase with newAdmin() first, and then deleteLastAdmin()', function(done) {
					
					firebase.refAdmins.once('value').then(function(snapshot) {
						return Object.entries(snapshot.val()).length;
					})
					.then(count => { firebase.newAdmin("test", "toDelete"); return count; })
					.then(count => { 
						firebase.deleteLastAdmin().then(_ => {
							firebase.refAdmins.once('value').then(function(snapshot) {
								var postCount = Object.entries(snapshot.val()).length;
								expect(count).to.equal(postCount); 
								done(); 
							}).catch(done); 
						});
					
					}).catch(done); 

				}); 

				it('should create new event entry on firebase, when newEvent is called', function(done) {
					var day = '2018-06-12'; 
					var starttime = '14:00'; 
					firebase.newEvent('test', 'test', day, starttime, 'test', 'test', 'testEvent'); 
					firebase.ref.child('event').child('testEvent').once('value').then(function(snapshot) {
						expect(snapshot.val().title).to.equal('test'); 
						firebase.deleteEvent('testEvent'); 
						done(); 
					}).catch(done); 
				}); 
				done(); 
			});

		})
		.on('error', (e) => console.log('Couldn\'t run firebase tests because connection down'));  

	})
	
})
	


