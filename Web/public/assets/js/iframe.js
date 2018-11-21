var iframe = document.getElementById('form-frame');

// change size depending on the window size
window.onresize = function(event) { 
	resizeIframe(iframe); 
}

iframe.contentWindow.onchange = resizeFrameByGroupSelector; 

// change size depending on content of the iframe
var resizeFrameByGroupSelector = function(event) {

	var targetGroupSelector; 
	var currentSize = parseInt(iframe.style.height.replace('px', '')); 

    if (event.target.id == 'targetGroup') {
    	targetGroupSelector = event.target;  
 
		switch(targetGroupSelector.value) {
		case 'All students': 
			iframe.style.height = (currentSize - 100) + 'px';  
			iframe.lastValue = 'all'; 
			break; 
		default:
			// If changing from 'All students' option, to non-all, expand
			if (iframe.lastValue == 'all')
				iframe.style.height = (currentSize + 100) + 'px';
			iframe.lastValue = 'not-all'; 
			break;  
		}

    } else if(event.target.id == 'eventOrNot') {
    	var eventOrNot = event.target; 
    	var eventDivShown = true; 

		if (eventOrNot.value == 'No event') {
			iframe.style.height = (currentSize - 600) + 'px'; 
			eventDivShown = false; 
		} else {
		   iframe.style.height = (currentSize + 600) + 'px'; 
			eventDivShown = true; 
		}
		
    } 
}


function resizeIframe(frame) {
    frame.style.height = frame.contentWindow.document.body.scrollHeight + 'px';
    iframe.contentWindow.onchange = resizeFrameByGroupSelector; 
}

