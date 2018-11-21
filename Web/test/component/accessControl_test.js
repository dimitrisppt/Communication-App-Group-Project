// NOTE: without the environment variable PASSWORD set to the right value, 
// no test will pass. 
var chai = require('chai').use(require('chai-as-promised')); 
var chaiHttp = require('chai-http'); 
var expect = chai.expect; 
var fail = expect.fail; 
var debug = require('debug')('firebase'); 
var server = require('../../app.js'); 
var serverRunner = require('../../bin/www'); // this automatically runs the server
var sleep = require('sleep'); 

chai.use(chaiHttp); 

var firebase = require('../../models/firebase'); 

var http = require('http'); 

var webdriver = require('selenium-webdriver'), 
	By = webdriver.By, 
	until = webdriver.until; 

var driver; 

// spiderByte@2018

describe('Access reject', function() {

	this.slow(500); 

	it('should redirect to login page when form to create new announcement requested', function(done) {
		chai.request(server)
			.get('/announcements/create')
			.end(function(err, res){
				expect(res).to.have.status(200); 
				expect(res.text).to.match(/(.|\n)*id=('|")connect_button("|')(.|\n)*/); 
				console.log(res.text); 
				done(); 
			}); 
	}); 

	it('should redirect to login page when staff list requested', function(done) {
		chai.request(server)
			.get('/admins')
			.end(function(err, res){
				expect(res).to.have.status(200); 
				expect(res.text).to.match(/(.|\n)*id=('|")connect_button("|')(.|\n)*/); 
				console.log(res.text); 
				done(); 
			}); 
	}); 

	it('should redirect to login page when new-admin form requested', function(done) {
		chai.request(server)
			.get('/admins/new')
			.end(function(err, res){
				expect(res).to.have.status(200); 
				expect(res.text).to.match(/(.|\n)*id=('|")connect_button("|')(.|\n)*/); 
				console.log(res.text); 
				done(); 
			}); 
	}); 

})

if (process.env.PASSWORD) {
	describe('Access grant', function() {
		this.slow(22000);

		var testCasesCount = 0; 

		before(function() {
			firebase.newAdmin('super tester', 'spider-byte-tester@outlook.com')
			firebase.newAdmin('normal tester', 'spiderbytehacker@outlook.com')
		})

		beforeEach(function() {
			
			driver =  new webdriver.Builder()
					.forBrowser('firefox')
					.build(); 
			driver.get('http://localhost:3000/logout');
			
		}); 

		afterEach(function() {
			if (testCasesCount < 5) {
				driver.close(); 
				testCasesCount++; 
			}
		})

		it('should allow an admin recorded on firebase to access new-announcement form', function(done) {
			
			driver.get('http://localhost:3000/announcements/create')
			.then(_ => driver.findElement(By.id('connect_button')))
			.then(loginButton => loginButton.click())
			.then(_ => sleep.sleep(4))
			.then(_ => driver.findElement(By.tagName('input')))
			.then(inputField => inputField.sendKeys('spider-byte-tester@outlook.com'))
			.then(_ => driver.findElement(By.id('idSIButton9')))
			.then(nextButton => nextButton.click())
			.then(_ => sleep.sleep(4))
			.then(_ => driver.findElement(By.name('passwd')))
			.then(passwordField => passwordField.sendKeys(process.env.PASSWORD))
			.then(_=> driver.findElement(By.id('idSIButton9')))
			.then(signInButton => signInButton.click())
			.then(_ => driver.get('http://localhost:3000/announcements/create'))
			.then(_ => driver.getTitle())
			.then(title => expect(title).to.equal('New announcement'))
			.then(_ => done())
			.catch(done); 

		}); 

		it('should allow an admin recorded on firebase to access staff list page', function(done) {

			driver.get('http://localhost:3000/admins')
			.then(_ => driver.findElement(By.id('connect_button')))
			.then(loginButton => loginButton.click())
			.then(_ => driver.findElement(By.tagName('input')))
			.then(inputField => inputField.sendKeys('spider-byte-tester@outlook.com'))
			.then(_ => driver.findElement(By.id('idSIButton9')))
			.then(nextButton => nextButton.click())
			.then(_ => sleep.sleep(4))
			.then(_ => driver.findElement(By.name('passwd')))
			.then(passwordField => passwordField.sendKeys(process.env.PASSWORD))
			.then(_=> driver.findElement(By.id('idSIButton9')))
			.then(signInButton => signInButton.click())
			.then(_ => driver.get('http://localhost:3000/admins'))
			.then(_ => driver.getTitle())
			.then(title => expect(title).to.equal('List of administrators'))
			.then(_ => done())
			.catch(done); 

		}); 

		it('should not allow an admin not recorded on firebase to access new-announcement form', function(done) {
			
			driver.get('http://localhost:3000/announcements/create')
			.then(_ => driver.findElement(By.id('connect_button')))
			.then(loginButton => loginButton.click())
			.then(_ => driver.findElement(By.tagName('input')))
			.then(inputField => inputField.sendKeys('spider-byte-super@outlook.com'))
			.then(_ => driver.findElement(By.id('idSIButton9')))
			.then(nextButton => nextButton.click())
			.then(_ => sleep.sleep(4))
			.then(_ => driver.findElement(By.name('passwd')))
			.then(passwordField => passwordField.sendKeys(process.env.PASSWORD))
			.then(_=> driver.findElement(By.id('idSIButton9')))
			.then(signInButton => signInButton.click())
			.then(_ => driver.get('http://localhost:3000/announcements/create'))
			.then(_ => driver.getTitle())
			.then(title => expect(title).to.equal('Log in to SpiderByte'))
			.then(_ => done())
			.catch(done); 

		}); 

		it('should not allow an admin not recorded on firebase to access staff list page', function(done) {
			
			driver.get('http://localhost:3000/admins')
			.then(_ => driver.findElement(By.id('connect_button')))
			.then(loginButton => loginButton.click())
			.then(_ => driver.findElement(By.tagName('input')))
			.then(inputField => inputField.sendKeys('spider-byte-super@outlook.com'))
			.then(_ => driver.findElement(By.id('idSIButton9')))
			.then(nextButton => nextButton.click())
			.then(_ => sleep.sleep(4))
			.then(_ => driver.findElement(By.name('passwd')))
			.then(passwordField => passwordField.sendKeys(process.env.PASSWORD))
			.then(_=> driver.findElement(By.id('idSIButton9')))
			.then(signInButton => signInButton.click())
			.then(_ => sleep.sleep(3))
			.then(_ => driver.get('http://localhost:3000/admins'))
		 	.then(_=> driver.getTitle())
			.then(title => expect(title).to.equal('Log in to SpiderByte')) 
			.then(_ => done())
			.catch(done); 

		}); 

		it('should not allow a non-super admin recorded on firebase to access new-admin form', function(done) {
			driver.get('http://localhost:3000/admins/new')
			.then(_ => driver.findElement(By.id('connect_button')))
			.then(loginButton => loginButton.click())
			.then(_ => driver.findElement(By.tagName('input')))
			.then(inputField => inputField.sendKeys('spiderbytehacker@outlook.com'))
			.then(_ => driver.findElement(By.id('idSIButton9')))
			.then(nextButton => nextButton.click())
			.then(_ => sleep.sleep(4))
			.then(_ => driver.findElement(By.name('passwd')))
			.then(passwordField => passwordField.sendKeys(process.env.PASSWORD))
			.then(_=> driver.findElement(By.id('idSIButton9')))
			.then(signInButton => signInButton.click())
			.then(_ => driver.get('http://localhost:3000/admins/new'))
			.then(_ => driver.getTitle())
			.then(title => expect(title).to.equal('Log in to SpiderByte')) 
			.then(_ => done())
			.catch(done); 
		}); 

		it('should allow a super-admin to access the new-admin form', function(done) {
			driver.get('http://localhost:3000/admins/new')
			.then(_ => driver.findElement(By.id('connect_button')))
			.then(loginButton => loginButton.click())
			.then(_ => driver.findElement(By.tagName('input')))
			.then(inputField => inputField.sendKeys('spider-byte-tester@outlook.com'))
			.then(_ => driver.findElement(By.id('idSIButton9')))
			.then(nextButton => nextButton.click())
			.then(_ => sleep.sleep(4))
			.then(_ => driver.findElement(By.name('passwd')))
			.then(passwordField => passwordField.sendKeys(process.env.PASSWORD))
			.then(_=> driver.findElement(By.id('idSIButton9')))
			.then(signInButton => signInButton.click())
			.then(_ => driver.get('http://localhost:3000/admins/new'))
			.then(_ => driver.getTitle())
			.then(title => expect(title).to.equal('Register new admin'))
			.then(_ => done())
			.catch(done); 
		}); 

		after(function(done) {
			console.log("TEST END")
			
			driver.close()
			.then(_ => 
				firebase.deleteLastAdmin()
				.then(_ => firebase.deleteLastAdmin())
			).then(_ => done())
			.catch(done); 
		})
	}); 
}

