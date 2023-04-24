// For input changes
$(document).ready(function() {
  // Base form elements
  var nameInput = $('#warranty-name');
  var companyInput = $('#warranty-company');
  var extraInfoInput = $('#extra-info');
  var startDateInput = $("#start-date");
  var endDateInput = $("#end-date");

  // corresponding error fields
  var nameError = $('#warranty-name-error');
  var companyError = $('#warranty-company-error');
  var extraError = $('#warranty-extra-info-error');
  var startError = $('#warranty-start-error');
  var endError = $('#warranty-end-error');

  // Add listeners for the date boxes to continually check validation
  startDateInput.on("input", validateInputs);
  endDateInput.on("input", validateInputs);

  // Perform front-end validations for warranty_name
  nameInput.on('input', function() {
    nameError.empty(); // Clear any existing error messages

    if (nameInput.val().length > 50) {
      nameInput.addClass('validation-error');
      nameError.text('must be 50 characters or less').show();
    } else {
      nameInput.removeClass('validation-error');
      nameError.hide();
    }
  });

  // Perform front-end validations for warranty_company
  companyInput.on('input', function() {
    companyError.empty();

    if (companyInput.val().length > 50) {
      companyInput.addClass('validation-error');
      companyError.text('must be 50 characters or less').show();
    } else {
      companyInput.removeClass('validation-error');
      companyError.hide();
    }
  });

  // Perform front-end validations for extra_info
  extraInfoInput.on('input', function() {
    extraError.empty();

    if (extraInfoInput.val().length > 250) {
      extraInfoInput.addClass('validation-error');
      extraError.text('must be 250 characters or less').show();
    } else {
      extraInfoInput.removeClass('validation-error');
      extraError.hide();
    }
  });

  function validateInputs() {
    var startDate = new Date(startDateInput.val());
    var endDate = new Date(endDateInput.val());

    // Call the validateDates() function to perform the validation
    var error = validateDates(startDate, endDate);

    if (error) {
      startDateInput.addClass('validation-error')
      startError.text(error).show();
    } else {
      startError.empty();
      startDateInput.removeClass('validation-error');
      console.log("Dates are valid.");
    }
  }

  function validateDates(startDate, endDate) {
    if (isNaN(startDate)) {
        return 'please select a date'
    }
    if (startDate >= endDate){
        return 'must be before end date OR end date should be cleared'
    } else {
        return null
    }
  }
});
