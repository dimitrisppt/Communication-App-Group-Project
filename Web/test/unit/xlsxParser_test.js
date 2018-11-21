var xlsxParser = require('../../models/xlsxParser'); 

var chai = require('chai').use(require('chai-as-promised')); 
var expect = chai.expect; 

var nonXlsxFileUrl = './test/test_helpers/spider.png'; 
var validFilterFileUrl = './test/test_helpers/dummyData_7_.xlsx'; 
var invalidFilterFileUrl = './test/test_helpers/invalid_filter_file.xlsx'; 

var testFileNames = [
	'dummyData_0_.xlsx', 
	'dummyData_7_.xlsx', 
	'dummyData_4_empty_rows.xlsx', 
	'dummyData_1024_.xlsx'
]; 


describe('xlsxParser acceptsHeaders', function() {

	this.slow(400); 

	it('should not accept invalid (not containing columns "programme", "status", "year", and "username") filter file headers', function(done) {
		var headersObject = xlsxParser.createFilterFileData(invalidFilterFileUrl).columnLabelMap; 
		expect(xlsxParser.acceptsHeaders(headersObject)).to.be.false; 
		done(); 
	}); 

	it('should accept headers of valid filter files', function(done) {
		testFileNames.forEach(function(fileName) {
			var target_path = process.cwd() + '\\test\\test_helpers\\' + fileName; 
			var headersObject = xlsxParser.createFilterFileData(target_path).columnLabelMap; 
			expect(xlsxParser.acceptsHeaders(headersObject)).to.be.true; 
		}); 
		done(); 
	}); 

}); 


// Parameterized test of different filter-files 
describe('xlsxParser allEmails', function() {

	this.slow(500); 

	testFileNames.forEach(function(fileName) {

		var numberOfEmailsExpected = parseInt(fileName.split('_')[1]); 
		var testCaseExpectationMessage = 'should return an array of length ' + 
				numberOfEmailsExpected + ' for test file ' + fileName; 

		it(testCaseExpectationMessage, function(done) {
			var target_path = process.cwd() + '\\test\\test_helpers\\' + fileName; 
			var filterFileData = xlsxParser.createFilterFileData(target_path); 
			var emailList = xlsxParser.allEmails(filterFileData.worksheet,
						 filterFileData.columnLabelMap); 
			
			expect(emailList.length).to.equal(numberOfEmailsExpected); 
			done(); 
		})

	}); 

})

describe('xlsxParser createFilterFileData().columnLabelMap', function() {

	this.slow(300); 

	it('should return object containing programme, status, and year when valid file provided', function(done) {
		var columnLabelMap = xlsxParser.createFilterFileData('./test/test_helpers/dummyData_0_.xlsx').columnLabelMap; 
		var columns = Object.keys(columnLabelMap); 
		expect(columns.includes('programme')).to.be.true; 
		expect(columns.includes('year')).to.be.true; 
		expect(columns.includes('status')).to.be.true; 
		done(); 
	}); 

	it('should return null when non xlsx file is the argument', function(done) {
		var headersObject = xlsxParser.createFilterFileData(nonXlsxFileUrl);  
		expect(headersObject).to.equal(null); 
		done(); 
	}); 

	it('should return empty object when xlsx file without all of the columns "programme", "status", "year", and "username" is the argument', function(done) {
		var headersObject = xlsxParser.createFilterFileData(invalidFilterFileUrl); 
		console.log(headersObject);  
		expect(Object.entries(headersObject).length).to.equal(0); 
		done(); 
	});

	it('should return object with some entries when xlsx file with all the required columns is the argument', function(done) {
		var headersObject = xlsxParser.createFilterFileData(validFilterFileUrl);  
		if (headersObject) {
			expect(Object.entries(headersObject.columnLabelMap).length).to.be.at.least(4); 
			done();
		}
	}); 

})

describe('xlsxParser getColumnValueSet(), for test helper dummyData_7_.xlsx,', function() {

	this.slow(300); 

	// Notice the tests depend on below objects, it's prerequisite that 
	// they are valid & they are already tested above
	var filterFileData = xlsxParser.createFilterFileData(validFilterFileUrl); 
	var columnLabelMap = filterFileData.columnLabelMap; 
	var worksheet = filterFileData.worksheet; 

	it('should return array of length 17 for column "programme"', function(done) {
		var columnValueSet = xlsxParser.getColumnValueSet(worksheet, columnLabelMap, 'programme'); 
		expect(columnValueSet.length).to.equal(17); 
		done(); 
	}); 

	it('should return array of length 5 for column "status"', function(done) {
		var columnValueSet = xlsxParser.getColumnValueSet(worksheet, columnLabelMap, 'status'); 
		expect(columnValueSet.length).to.equal(5); 
		done(); 
	}); 

	it('should return array of length 4 for column "year"', function(done) {
		var columnValueSet = xlsxParser.getColumnValueSet(worksheet, columnLabelMap, 'year'); 
		expect(columnValueSet.length).to.equal(4); 
		done(); 
	}); 

})

class TestCase {
	constructor(expectedResultLength, targetProgrammes, targetStatuses, targetYears) {
		this.expectedResultLength = expectedResultLength; 
		this.targetProgrammes = targetProgrammes; 
		this.targetStatuses = targetStatuses; 
		this.targetYears = targetYears; 
	}
}

describe('xlsxParser createMailingList(), for test helper dummyData_7_.xlsx', function() {
	var filterFileData = xlsxParser.createFilterFileData(validFilterFileUrl); 
	var columnLabelMap = filterFileData.columnLabelMap; 
	var worksheet = filterFileData.worksheet; 
	var testCases = [
		new TestCase(0, [], [], []), 
		new TestCase(1, ["BEng Electronic and Information Engineering"], [], []), 
		new TestCase(2, ["BEng Electronic and Information Engineering", 
						 "BEng Electronic Engineering"], [], []),
		new TestCase(3, ["BEng Electronic Engineering"], 
						["Interrupted", "Dormant"], []),
		new TestCase(4, ["BEng Electronic Engineering with Management"],
						["Dormant"], [1, 2]),
		new TestCase(3, ["BSc Computer Science with Management",
						"BSc Computer Science with Management and a Year Abroad",
						"BSc Computer Science with Management and a Year in Industry"], 
						["Interrupted"], 
						[1, 2]),
		new TestCase(3, ["MSci Computer Science"], [], []),
		new TestCase(2, [], [], [3, 4]),
		new TestCase(1, [], [], [2]),
		new TestCase(0, ["BSc Mathematics and Computer Science"], [], [])
	]; 

	testCases.forEach(testCase => {
		var countProgrammes = testCase.targetProgrammes.length; 
		var countStatuses = testCase.targetStatuses.length; 
		var countYears = testCase.targetYears.length; 
		var totalOptions = countProgrammes + countYears + countStatuses; 

		var testCaseExpectationMessage = "should return array of length " + 
			testCase.expectedResultLength + " for total " + 
				totalOptions + " option(s) specified"; 
		it(testCaseExpectationMessage, function(done) {
			var mailingList = xlsxParser.createMailingList(worksheet, columnLabelMap, 
				testCase.targetProgrammes,
				testCase.targetStatuses, 
				testCase.targetYears); 
			expect(mailingList.length).to.equal(testCase.expectedResultLength);  
			done(); 
		})
	})

})

