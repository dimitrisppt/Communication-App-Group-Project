var chai = require('chai'); 
var chaiHttp = require('chai-http'); 
var server = require('../../app.js'); 
var expect = chai.expect; 
var serverRunner = require('../../bin/www'); // this automatically runs the server
var accessController = require('../../controllers/accessController'); 
var xlsxParser = require('../../models/xlsxParser'); 

var webdriver = require('selenium-webdriver'), 
	By = webdriver.By, 
	until = webdriver.until; 

var driver =  new webdriver.Builder()
	.forBrowser('firefox')
	.build(); 
var firebase = require('../../models/firebase'); 
chai.use(chaiHttp); 

// Testing semantics for making requests to announcement pages 
describe('Announcement request', function() {
	this.slow(500); 

	before(function() {
		process.env.testWithoutAccessCheck = 'true';
	}); 

	it('should get HTML page at GET /announcements/create with status 200 OK', function(done) {
		chai.request(server)
			.get('/announcements/create')
			.end(function(err, res){
				expect(res).to.have.status(200); 
				expect(res).to.be.html; 			
				done(); 
			}); 
	}); 

	it('should give status 400 BAD REQUEST, and redisplay HTML when submitted without title', function(done) {
		chai.request(server)
			.post('/announcements/create')
			.send({'title':'', 'content':'Hi', 'tag':'TEST', 'eventOrNot' : 'No'})
			.end(function(err, res) {
				expect(res).to.have.status(400); // bad request 
				expect(res).to.be.html; 

				done(); 
			}); 
	}); 

	it('should give status 400 BAD REQUEST, and redisplay HTML when submitted without content', function(done) {
		chai.request(server)
			.post('/announcements/create')
			.send({'title':'NEWS', 'content': '', 'tag':'TEST', 'eventOrNot' : 'No'})
			.end(function(err, res) {
				expect(res).to.have.status(400); // bad request 
				expect(res).to.be.html; 
				done(); 
			}); 
	}); 

	it('should give status 200 OK, when both title, and content are given', function(done) {
		var announcement = {
			title: 'AUTO-test',
			content: 'test',
			hasEvent: false,
			tag: 'TEST',
			pdfEncoding: 'smth',
			readingList: ["none"],
			photoB64: '', 
			targetGroup: 'All students', 
			eventOrNot: 'No'
		}
		chai.request(server)
			.post('/announcements/create')
			.send(announcement)
			.end(function(err, res) { 
				firebase.deleteAnnouncement('2018-03-29-16%3A07%3A30-990'); 
				expect(res).to.have.status(200); 
				done(); 
			})
	}); 

	after(function() {

		process.env.testWithoutAccessCheck = '';  

	}); 
}); 

// Testing semantics for announcement form behaviour 
describe('Announcement form', function() {

	this.slow(1500); 
	var submitButton; 

	before(function() {
		process.env.testWithoutAccessCheck = 'true';
	}); 

	after(function() {
		process.env.testWithoutAccessCheck = 'false'; 
	}); 

	// before each test case, requests a fresh form 
	beforeEach(function() {
		driver.get('http://localhost:3000/announcements/form');  
		submitButton = driver.findElement(By.id('btn-submit'));
	}); 

	it('should display success message if there are no errors in submission', function(done) {
		driver.findElement(By.id('content'))
		.then(contentField => contentField.sendKeys('For all the mothers in the world!'))
		.then(_ => driver.wait(until.elementLocated(By.id('title'))))
		.then(titleField => titleField.sendKeys('This message is sent by auto-test'))
		.then(_ => submitButton.click())
		.then(_ => driver.wait(until.elementLocated(By.className('text-success'))))
		.then(successMessageElement => successMessageElement.getText())
		.then(successMessageText => {
			expect(successMessageText).to.equal('Sent successfully')
			done(); 
		})	
		.catch(done); 

	}); 

	it('should clear the fields, when cancel is clicked', function(done) {

		driver.findElement(By.id('content'))
		.then(contentField => contentField.sendKeys('For all the mothers in the world!'))
		.then(_ => driver.wait(until.elementLocated(By.id('title'))))
		.then(titleField => titleField.sendKeys('This message is sent by auto-test'))
		.then(_=> driver.findElement(By.id('cancel')))
		.then(cancelButton => cancelButton.click())
		.then(_ => driver.wait(until.elementLocated(By.id('title'))))
		.then(titleField => titleField.getAttribute('value'))
		.then(titleText => expect(titleText).to.equal(''))
		.then(_ => driver.wait(until.elementLocated(By.id('content'))))
		.then(contentField => contentField.getText())
		.then(contentText => {
			expect(contentText).to.equal(''); 
			done(); 
		})
		.catch(done); 
	}); 

	it('should display not display success message, when submitted with neither title or content', function(done) {
	
		var actualNumberOfErrorMessages; 

		submitButton.click()
		.then(_ => driver.findElements(By.className('text-success')))
		.then(successMessages => {
			expect(successMessages.length).to.equal(0); 
			done(); 
		})
		.catch(done); 
	}); 

	it('should not erase the value in the title field, if submission error occurs', function(done) {
		
		driver.findElement(By.id('title'))
		.then(titleField => titleField.sendKeys('Spread love'))
		.then(_ => submitButton.click())
		.then(_ => driver.wait(until.elementsLocated(By.className('text-danger'))))
		.then(_ => driver.wait(until.elementLocated(By.id('title'))))
		.then(titleField => titleField.getAttribute('value'))
		.then(titleTextAfterError => {
			expect(titleTextAfterError).to.equal('Spread love'); 
			done(); 
		})
		.catch(done); 

	}); 

	it('should display fresh form if submission successful', function(done) {

		driver.findElement(By.id('content'))
		.then(contentField => contentField.sendKeys('For all the mothers in the world!'))
		.then(_ => driver.wait(until.elementLocated(By.id('title'))))
		.then(titleField => titleField.sendKeys('This message is sent by auto-test'))
		.then(_ => submitButton.click())
		.then(_ => driver.wait(until.elementLocated(By.id('title'))))
		.then(titleField => titleField.getAttribute('value'))
		.then(titleText => expect(titleText).to.equal(''))
		.then(_ => driver.wait(until.elementLocated(By.id('content'))))
		.then(contentField => contentField.getText())
		.then(contentText => {
			expect(contentText).to.equal(''); 
			done(); 
		})
		.catch(done); 

	}); 

	it('should not erase the text in the content textarea, if submission error occurs', function(done) {

		driver.findElement(By.id('content'))
		.then(contentField => contentField.sendKeys('Spread love'))
		.then(_ => submitButton.click())
		.then(_ => driver.wait(until.elementsLocated(By.className('text-danger'))))
		.then(_ => driver.wait(until.elementLocated(By.id('content'))))
		.then(contentField => contentField.getAttribute('value'))
		.then(contentTextAfterError => {
			expect(contentTextAfterError).to.equal('Spread love'); 
			driver.quit(); 
			done(); 
		})
		.catch(done); 

	});   

}); 

describe('\'Filtered list of students\' target-option', function() {

	this.slow(500); 

	before(function() {
		process.env.testWithoutAccessCheck = 'true';
	}); 

 	after(function() {
		process.env.testWithoutAccessCheck = 'false'; 
	}); 

 	var emptyFilterFileUrl = './test/test_helpers/dummyData_0_.xlsx'; 
	var filterFileUrl = './test/test_helpers/dummyData_7_.xlsx'; 
	var nonXlsxFileUrl = './test/test_helpers/spider.png'; 
	var invalidFilterFileUrl = './test/test_helpers/invalid_filter_file.xlsx'; 
	it('should give 400 BAD REQUEST for attempting to target without req.session.worksheet', function(done) {
		var announcement = {
			title: 'AUTO-test',
			content: 'test',
			hasEvent: false,
			tag: 'TEST',
			pdfEncoding: 'smth',
			readingList: ["none"],
			photoB64: '', 
			targetGroup: 'Filtered list of students', 
			eventOrNot: 'No',
			mailingList: 'X'
		}

		chai.request(server)
		.post('/announcements/create')
		.send(announcement)
		.end(function(err, res) { 
			if (err) console.log(err); 
			expect(res.status).to.equal(400); 
			done(); 
		}); 
	});

	it('should not be from non-xlsx file, and give response 400 when such is attempted', function(done) {
		chai.request(server)
			.post('/announcements/groupStudents')
			.field('mailingList', 'x') // FRONTEND JAVASCRIPT DOES NOT WORK IN CHAI
			.attach('filter-file', nonXlsxFileUrl)
			.end(function(err, res) {
				if (err) console.log(err); 
				expect(res.status).to.equal(400); 
				var hasRightMessage = res.text.
					includes('Filter file must be in .xlsx format'); 
				expect(hasRightMessage).to.be.true; 
				done(); 
			}); 
	}); 

	it('should be from an xlsx file, with at least the following columns: programme, status, year, and username', function(done) {
		chai.request(server)
			.post('/announcements/groupStudents')
			.field('mailingList', 'x')
			.attach('filter-file', filterFileUrl)
			.end(function(err, res) {
				if (err) console.log(err); 
				expect(res.status).to.equal(200); 
				var hasRightMessage = res.text.
					includes('targetProgrammes'); 
				expect(hasRightMessage).to.be.true; 
				done(); 
			}); 
	}); 
	
	it('should not be from xlsx file, which does NOT contain the columns: programme, status, year, and username', function(done) {
		chai.request(server)
		.post('/announcements/groupStudents')
		.field('mailingList', 'x')
		.attach('filter-file', invalidFilterFileUrl)
		.end(function(err, res) {
			if (err) console.log(err); 
			expect(res.status).to.equal(400); 
			var hasRightMessage = res.text.
				includes('No filter-file detected with the following columns'); 
			expect(hasRightMessage).to.be.true; 
			done(); 
		}); 
	}); 

}); 

describe('\'By k-number\' target-option', function() {

	this.slow(500); 

	before(function() {
		process.env.testWithoutAccessCheck = 'true';
	}); 

	after(function() {
		process.env.testWithoutAccessCheck = 'false'; 
	}); 


	it('should submit successfully if one k-number provided', function(done) {
		var announcement = {
			title: 'AUTO-test',
			content: 'test',
			hasEvent: false,
			tag: 'TEST',
			pdfEncoding: 'smth',
			readingList: ["none"],
			photoB64: '', 
			targetGroup: 'All students', 
			eventOrNot: 'No',
			mailingList: 'X'
		}

		chai.request(server)
		.post('/announcements/create')
		.send(announcement)
		.end(function(err, res) {
			if (err) console.log(err); 
			expect(res.status).to.equal(200); 
			var hasRightMessage = res.text.
				includes('Sent successfully'); 
			expect(hasRightMessage).to.be.true; 		
			done(); 
		}); 
	});

	it('should submit successfully if 5 k-numbers provided comma-separated', function(done) {
		var announcement = {
			title: 'AUTO-test',
			content: 'test',
			hasEvent: false,
			tag: 'TEST',
			pdfEncoding: 'smth',
			readingList: ["none"],
			photoB64: '', 
			targetGroup: 'All students', 
			eventOrNot: 'No',
			mailingList: 'a, b, c, d, e'
		}

		chai.request(server)
		.post('/announcements/create')
		.send(announcement)
		.end(function(err, res) { 
			if (err) console.log(err); 
			expect(res.status).to.equal(200); 
			var hasRightMessage = res.text.
				includes('Sent successfully'); 
			expect(hasRightMessage).to.be.true; 		
			done(); 
		}); 

	});
})
