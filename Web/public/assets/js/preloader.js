var loaderWrapper = document.querySelector('.loader-wrapper'); 

setTimeout(function() {

	// loaderWrapper.style.opacity = 0; 

	var wrapperTop = 0; 
	function loop() {
	 	if (wrapperTop > -110) { 
	 		loaderWrapper.style.top = wrapperTop + '%'; 
	 		wrapperTop--; 
	 		setTimeout(loop, 1); 
	 	}
	}
	
	loop(); 

	 setTimeout(function() {
		loaderWrapper.className += ' hidden'; 
	}, 1500);

}, 1280); 




