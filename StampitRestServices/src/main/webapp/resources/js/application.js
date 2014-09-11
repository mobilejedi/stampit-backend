$('#registrationForm').on('submit', function(event) {
	alert('Function has been called');
	event.preventDefault();
	$.support.cors = true;
	console.log('Dati iviati: ' + $('#registrationForm').serialize());
	var form = $(this);
	$.ajax({
		url:'http://54.191.5.48:8085/StampitRestServices/registerCustomer', 
		contentType: "application/json",
        dataType: "text",
		type: 'POST',
		data: JSON.stringify({
			username: $("#username").val(),
			password: $("#password").val(),
			firstName: $("#firstName").val(),
			lastName: $("#lastName").val(),
			email: $("#email").val(),
			phone: $("#phone").val()
		}),
		success: function(result) {
			alert('Your registration has been successful.');
		},
		error: function(request, errorType, errorMessage) {
			alert('Your registration has not been successful.');
		}		
	});
});