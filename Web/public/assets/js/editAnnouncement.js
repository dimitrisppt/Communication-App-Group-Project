$('.dt-editAnnouncements').each(function () {
  $(this).on('click', function(evt) {
    $this = $(this);
    var dtRow = $this.parents('tr');

    if(confirm("Do you really want to edit this announcement from the list?")){
      var announcement = $this.context.dataset.firebaseKey; 
      window.location.replace('/announcements/edit/' + announcement); 

    }
    else{
    	return false;
    }
  });
});
      
$('#myModal').on('hidden.bs.modal', function (evt) {
  $('.modal .modal-body').empty();
});