/** 
 * This module is for reading data from .xlsx format files. 
 * The functions of this module are of functional-programming style
 * as their return value ideally depends only the parameters. 
 */  
var XLSX = require('xlsx'); 
var REQUIRED_HEADERS = ['programme', 'status', 'year', 'username']; 

/** 
 * @return Object with two entries. First, Object with keys as the column names, and the values 
 * as the column label as in the file given. Second, worksheet file generated from reading file.
 * @return null if filterFileUrl is falsy, or of non xlsx file 
 * @return Object empty object if file doesn't qualify as filter-file
 * @param filterFileUrl String url of file given 
 */ 
var createFilterFileData = function(filterFileUrl) {

	if (!filterFileUrl || !filterFileUrl.endsWith('.xlsx')) return null; 

	var columnLabelMap = {}; 
	var workbook = XLSX.readFile(filterFileUrl); 
	var worksheet = workbook.Sheets[workbook.SheetNames[0]]; 

	var cells = Object.keys(worksheet); 

	var firstRowCells = cells.filter(cell => {
		if (!cell.toString().match(/[A-Z]\d+/)) return false; 
		var rowNumber = cell.match(/\d+/)[0]; 
		return rowNumber == 1; 
	})

	firstRowCells.forEach(cell => {
		var cellValue = worksheet[cell].v; 
		if ((typeof cellValue) != "string") return; 
		columnLabelMap[cellValue.toLowerCase()] = cell[0]; 
	}); 

	if (!acceptsHeaders(columnLabelMap)) return {}; 
	return { columnLabelMap: columnLabelMap, worksheet: worksheet}; 

}; 

/** 
 * @return Array for set of all values in 'column' in 'file', as an array 
 * @param worksheet Object worksheet of a filter file
 * @param columnLabelMap Object telling which label is for which column 
 * @param columnName String name of the 'column'
 */ 
var getColumnValueSet = function(worksheet, columnLabelMap, columnName) {

	var colmunValuesSet = new Set([]); 
	for (var cell in worksheet) {
		if (cell.toString() === (columnLabelMap[columnName] + '1')) continue; 
		if (cell.toString()[0] === columnLabelMap[columnName]) {
			colmunValuesSet.add(worksheet[cell].v); 
		}
	}

	var columnValuesArray= Array.from(colmunValuesSet); 
	return columnValuesArray; 

}; 

/** 
 * @return Array of all emails in a given file
 * @param worksheet Object worksheet of a filter file
 * @param columnLabelMap object to find column-label of the email column
 */ 
var allEmails = function(worksheet, columnLabelMap) {

	var emailColumnLabel = columnLabelMap['username']
	var emailColumn = []; 

	for (var cell in worksheet) {
		if (cell.toString() === (emailColumnLabel + '1')) continue; 
		if (cell.toString()[0] === emailColumnLabel) {
			emailColumn.push(worksheet[cell].v); // if in email column, push value
		}
	}

	return emailColumn; 

}; 

// set union operation as helper for createMailingList
Set.prototype.union = function(setB) {

    for (var elem of setB) {
        this.add(elem);
    }

}; 

/** 
 * @return Array representing set of emails of students with the given
 * 'programmes', 'statuses', and 'years' from the given 'file'. 
 * @param worksheet Object worksheet of a filter file
 * @param columnLabelMap Object containing column name to column label map
 * @param targetProgrammes Array of 'programmes' as strings
 * @param targetStatuses Array of 'statuses' as strings
 * @param targetYears Array of 'years' as strings
 */ 
var createMailingList = function(worksheet, columnLabelMap, targetProgrammes, 
								 targetStatuses, 
								 targetYears) {

	if (!worksheet || !columnLabelMap) return; 
	var mailingList = new Set([]); 

	if (isIterable(targetProgrammes))
		targetProgrammes.forEach(programme => 
		mailingList.union(getStudentsByColumn(columnLabelMap['programme'], columnLabelMap,
						programme, worksheet))); 

	if (isIterable(targetStatuses))
		targetStatuses.forEach(status => 
		mailingList.union(getStudentsByColumn(columnLabelMap['status'], columnLabelMap,
						status, worksheet))); 

	if (isIterable(targetYears))
		targetYears.forEach(year => 
		mailingList.union(getStudentsByColumn(columnLabelMap['year'], columnLabelMap,
						year, worksheet)));   

	return Array.from(mailingList); 

}; 

/** 
 * @return true only if provided object containing column headers as 
 * its keys has the keys given in REQUIRED_HEADERS constant
 */ 
var acceptsHeaders = function(headersObject) {

	if (!headersObject) return false; 
	var toReturn = true; 
	var columnHeaders = Object.keys(headersObject); 

	REQUIRED_HEADERS.forEach(header => {
		if (!columnHeaders.includes(header)) toReturn = false;
	})

	return toReturn; 

}; 

/** 
 * @return Set of emails of students who belong to specified 'group'
 * @param columnLabel Char label of column in which to search for group name
 * @param columnLabelMap Object to find column label for the emails 
 * @param groupName String name of the 'group' 
 * @param worksheet Object worksheet containing all data
 */ 
function getStudentsByColumn(columnLabel, columnLabelMap, groupName, worksheet) {
 
	var emailColumnLabel = columnLabelMap['username']; 

	var studentSet = new Set([]); 
	for (var cell in worksheet) {
		if (cell.toString() == (columnLabel + '1')) continue; // ignore first row
		if (cell.toString()[0] == columnLabel) {

			if (worksheet[cell].v == groupName) {
				var rowNumber = cell.toString().match(/\d+/)[0]; 

				var studentEmail = worksheet[emailColumnLabel + rowNumber]; 
				if (studentEmail) studentSet.add(studentEmail.v); 
			}
				
		}
	}

	return studentSet; 
}

/** 
 * Helper function to check whether object is iterable
 */ 
function isIterable(obj) {
  if (!obj) return false;
  return Array.isArray(obj); 
}

module.exports = {
	allEmails, 
	getColumnValueSet,
	createFilterFileData, 
	createMailingList, 
	acceptsHeaders
}
