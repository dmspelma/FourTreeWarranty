$(document).ready(function() {
  var timeout = 3000;

  function dismissAlert() {
    $('.alert').alert('close');
  }

  setTimeout(dismissAlert, timeout);
});
