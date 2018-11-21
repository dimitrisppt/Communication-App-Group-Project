var targetSelect = document.querySelector('#targetGroup'); // initially displayed menu
var filterForm = document.getElementById('filterForm'); // optionally displayed if filtered chosen
var filterFile = document.getElementById('filterFile'); 
var knumberDiv = $('#kNo'); 
var knumberField = document.getElementById('knumber'); // JQuery methods not working as expected, so this is added
var filterFormQuery = $('#filterForm');  
var titleField = document.getElementById('title'); 
var contentField = document.getElementById('content'); 

var submitButton = $('#btn-submit'); 

// toggle the file attacher, and knumber-field as appropriate
var fileAttacherShown = false; 
var knumberDivShown = false; 
var submitButtonShown = true; 
var knumberErrorShown = false; 

// if success message is there, disappear after 1500ms
setTimeout(function() {
	$('.text-success').slideToggle(); 
}, 1500); 

document.getElementById('kNo').style.display = 'none'; 

// Code for 'Filtered list of students' target group option 
if (filterForm) { 

	filterForm.style.display = 'none';  
	targetSelect.onchange = function() {

		if (targetSelect.value == 'Filtered group of students') {
			if (!fileAttacherShown) filterFormQuery.slideToggle(); 
			if (submitButtonShown) submitButton.slideToggle(); 
			fileAttacherShown = true; 
			submitButtonShown = false; 
		} else {
			if (fileAttacherShown) filterFormQuery.slideToggle(); 
			if (!submitButtonShown) submitButton.slideToggle(); 
			fileAttacherShown = false; 
			submitButtonShown = true; 
		} 

		if (targetSelect.value == 'By k-number') {
			if (!knumberDivShown) {
				knumberField.required = true;
				knumberDiv.slideToggle(); 
			}
			knumberDivShown = true; 
		} else {
			if (knumberDivShown) {
				knumberField.required = false; 
				knumberDiv.slideToggle();   
			}
			knumberDivShown = false; 
		}
		
	};  

	if (filterFile) filterFile.onchange = function() {
		// ADD HIDDDEN FIELDS SO TO PREVENT STARTING OVER
		var titleInput = document.createElement('input'); 
		titleInput.setAttribute('type', 'hidden'); 
		titleInput.setAttribute('name', 'title'); 
		titleInput.setAttribute('value', titleField.value); 

		var contentInput = document.createElement('input')
		contentInput.setAttribute('type', 'hidden'); 
		contentInput.setAttribute('name', 'content'); 
		contentInput.setAttribute('value', contentField.value); 
		filterForm.appendChild(titleInput); 
		filterForm.appendChild(contentInput); 
		
		filterForm.submit(); 
	}

}

// when the select options show, make sure at least one gets a value 
var targetFields = [
	document.getElementById('targetProgramme'),
	document.getElementById('targetStatus'),
	document.getElementById('targetYear')]; 

if (targetFields[0]) 
	targetFields.forEach(field => {
		field.onchange = function(event) {

			var nonEmpties = targetFields.filter(field => field.value); 

			if(nonEmpties.length > 0) {
				targetFields.forEach(field => field.required = false); 
			} else {
				targetFields.forEach(field => field.required = true); 
			}
			
		}
	}); 

// Code for 'By k-number' target group option 
var knumberQuery = $('#knumber'); 
knumberQuery.on('beforeItemAdd', function(event) {
	var kclified = kclify(event.item); 
	(kclified) ? event.item = kclified : event.cancel=true; 
});

knumberQuery.on("invalid", function(event) {
	event.preventDefault(); 
	if(!knumberErrorShown) $('#knumberError').slideToggle(); 
	knumberErrorShown = true; 
});

function kclify(prefix) {
	var purePrefix = prefix.split('@')[0]; 

	if (purePrefix === '' || 
			purePrefix[0] != 'k' || 
			purePrefix.length != 8) {
		return '';  
	} else {
		return purePrefix + '@kcl.ac.uk'; 
	}
}

// Code for event fields
var eventOrNot = $('#eventOrNot');
var eventDivQuery = $('#eventDiv');
document.getElementById('eventOrNot').value = 'No event'; 
eventDivQuery.hide();

eventOrNot.on("change", function(event) {
	eventDivQuery.slideToggle(); 
});
