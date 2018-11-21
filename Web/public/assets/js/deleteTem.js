$('.dt-deleteTem').each(function () {
  $(this).on('click', function(evt) {
    $this = $(this);
    var dtRow = $this.parents('tr');

    if(confirm("Do you really want to remove this template from the list?")){
      var template = $this.context.dataset.firebaseKey; 
      window.location.replace('/templateList/delete/' + template); 

    }
    else{
    	return false;
    }
  });
});
      
$('#myModal').on('hidden.bs.modal', function (evt) {
  $('.modal .modal-body').empty();
});