$('.dt-delete').each(function () {
  $(this).on('click', function(evt) {
    $this = $(this);
    var dtRow = $this.parents('tr');

    if(confirm("Do you really want to remove this person from staff list?")){
      
      var adminKey = $this.context.dataset.firebaseKey; 

      window.location.replace('/admins/delete/' + adminKey); 
    }
  });
});
      
$('#myModal').on('hidden.bs.modal', function (evt) {
  $('.modal .modal-body').empty();
});