$(document).ready(function() {
  // Get the start date and end date input fields by their ids
  var startDateField = $('#start-date');
  var endDateField = $('#end-date');

  // Add a change event listener on the end date input field
  endDateField.on('change', function() {
    // Parse the start date and end date input values as Date objects
    var startDate = new Date(startDateField.val());
    var endDate = new Date(endDateField.val());

    if (startDate !== '' && endDate !== '' && new Date(startDate) > new Date(endDate)) {
      // If end date is earlier than start date, do:
      $(this).addClass('date-validation-error');
      alert('End date must be greater than start date');

    } else {
      // Otherwise, remove the CSS class
      $(this).removeClass('date-validation-error');
    }
  });
});
