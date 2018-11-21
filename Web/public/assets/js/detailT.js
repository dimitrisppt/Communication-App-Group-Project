$('.btn-detailT').each(function () {

  $(this).on('click', function(evt) {
    $this = $(this);
    var dtRow = $this.parents('td');

    console.log($this); 

    var templateKey = $this.context.dataset.firebaseKey; 
   
    window.location.replace('/templateList/detail/' + templateKey); 



  });
});
      
$('#myModal').on('hidden.bs.modal', function (evt) {
  $('.modal .modal-body').empty();
});