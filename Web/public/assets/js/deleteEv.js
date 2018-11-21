$('.dt-deleteEv').each(function () {
  $(this).on('click', function(evt) {
    $this = $(this);
    var dtRow = $this.parents('tr');

    if(confirm("Do you really want to remove this event from the list?")){
      var event = $this.context.dataset.firebaseKey; 
      window.location.replace('/event/delete/' + event); 

    }
    else{
    	return false;
    }
  });
});
      
$('#myModal').on('hidden.bs.modal', function (evt) {
  $('.modal .modal-body').empty();
});