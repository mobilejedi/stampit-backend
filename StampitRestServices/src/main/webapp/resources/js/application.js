$(document).ready(function () {
    var url = window.location.protocol + "//" + window.location.host + window.location.pathname;
    var baseUrl = url.substr(0, url.lastIndexOf("/"));
    var reset = function() {
        $('#successMessage').addClass('hide');
        $('#errorMessage').addClass('hide');
        $(".progress").removeClass('hide');
    };
    $('#registrationForm').on('submit', function (event) {
        reset();
        alert(baseUrl);
        event.preventDefault();
        $.support.cors = true;
        console.log('Dati iviati: ' + $('#registrationForm').serialize());
        var form = $(this);
        $.ajax({
            url: baseUrl + "/registerCustomer",
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
            success: function() {
                $(".progress").addClass('hide');
            },
            error: function (request, errorType, errorMessage) {
                $(".progress").addClass('hide');
                console.log('errorType: ' + errorType);
                console.log('errorMessage: ' + errorMessage);
                if (errorType === 'Abort') {
                    $('#successMessage').addClass('hide');
                    $('#errorMessage').removeClass('hide').text('The service is currently unavailable: please try again later.');
                }

            },
            statusCode: {
                422: function () {
                    $('#successMessage').addClass('hide');
                    $('#errorMessage').removeClass('hide').text('The username you inserted already exist: please select another one');
                },
                408: function () {
                    $('#successMessage').addClass('hide');
                    $('#errorMessage').removeClass('hide').text('There was a problem processing your request.');
                },
                404: function () {
                    $('#successMessage').addClass('hide');
                    $('#errorMessage').removeClass('hide').text('The service is currently unavailable.');
                },
                201: function () {
                    $('#successMessage').removeClass('hide');
                    $('#errorMessage').addClass('hide');
                }
            }
        });
    });

    $('#loginForm').on('submit', function (event) {
        reset();
        alert(baseUrl);
        event.preventDefault();
        $.support.cors = true;
        console.log('Dati iviati: ' + $('#registrationForm').serialize());
        var form = $(this);
        $.ajax({
            url: baseUrl + "/authenticateCustomer",
            contentType: "application/json",
            dataType: "text",
            type: 'POST',
            data: JSON.stringify({
                username: $("#username").val(),
                password: $("#password").val()
            }),
            success: function() {
                $(".progress").addClass('hide');
            },
            error: function (request, errorType, errorMessage) {
                $(".progress").addClass('hide');
                console.log('errorType: ' + errorType);
                console.log('errorMessage: ' + errorMessage);
                if (errorType === 'Abort') {
                    $('#successMessage').addClass('hide');
                    $('#errorMessage').removeClass('hide').text('The service is currently unavailable: please try again later.');
                }

            },
            statusCode: {
                401: function () {
                    $('#successMessage').addClass('hide');
                    $('#errorMessage').removeClass('hide').text('Username and/or password are incorrect.');
                },
                408: function () {
                    $('#successMessage').addClass('hide');
                    $('#errorMessage').removeClass('hide').text('There has been a problem processing your request.');
                },
                404: function () {
                    $('#successMessage').addClass('hide');
                    $('#errorMessage').removeClass('hide').text('The service is currently unavailable.');
                },
                200: function () {
                    $('#successMessage').removeClass('hide').text("Successfully authenticated.");
                    $('#errorMessage').addClass('hide');
                }
            }
        });
    });
});