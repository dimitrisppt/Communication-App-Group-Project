$('.dt-deletes').each(function () {
  $(this).on('click', function(evt) {
    $this = $(this);
    var dtRow = $this.parents('tr');

    if(confirm("Do you really want to remove this announcement from the list?")){
      
      var announcementKey = $this.context.dataset.firebaseKey; 
      window.location.replace('/listAnnouncements/delete/' + announcementKey); 

    }
    else{
    	return false;
    }
  });
});
      
$('#myModal').on('hidden.bs.modal', function (evt) {
  $('.modal .modal-body').empty();
});