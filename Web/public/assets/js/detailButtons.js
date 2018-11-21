$('.btn-detail').each(function () {

  $(this).on('click', function(evt) {
    $this = $(this);
    var dtRow = $this.parents('td');

    console.log($this); 

    var announcementKey = $this.context.dataset.firebaseKey; 
   
    window.location.replace('/listAnnouncements/detail/' + announcementKey); 



  });
});
      
$('#myModal').on('hidden.bs.modal', function (evt) {
  $('.modal .modal-body').empty();
});