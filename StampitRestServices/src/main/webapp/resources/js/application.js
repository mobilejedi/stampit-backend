$(document).ready(function() {
	$('#registrationForm').on('submit', function(event) {
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
			error: function(request, errorType, errorMessage) {			
				console.log('errorType: ' + errorType);
				console.log('errorMessage: ' + errorMessage);
				if(errorType === 'Abort') {
					$('#successMessage').addClass('hide');
					$('#errorMessage').removeClass('hide').text('The service is currently unavailable: please try again later.');
				}
									
			},
			statusCode: {
				422: function() {
					$('#successMessage').addClass('hide');	
					$('#errorMessage').removeClass('hide').text('The username you inserted already exist: please select another one');
				},
				408: function() {
					$('#successMessage').addClass('hide');	
					$('#errorMessage').removeClass('hide').text('There has been a problem processing your request.');
				},
				201: function() {
					$('#successMessage').removeClass('hide');
					$('#errorMessage').addClass('hide');
				}
			}
		});
	});
});