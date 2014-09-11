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
			success: function(result) {
				$('#errorMessage').addClass('hide');
				$('#successMessage').removeClass('hide');
				form.reset();
			},
			error: function(request, errorType, errorMessage) {			
				console.log('errorType: ' + errorType);
				console.log('errorMessage: ' + errorMessage);
				if(errorMessage === 'Unprocessable Entity') {
					$('#errorMessage').removeClass('hide').text('The username you inserted already exist: please select another one');
				} else {
					$('#errorMessage').removeClass('hide').text('The service is currently unavailable: please try again later.');
				}
				$('#successMessage').addClass('hide');						
			}		
		});
	});
});