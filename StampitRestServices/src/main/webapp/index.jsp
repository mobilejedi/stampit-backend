<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Stampit test registration form</title>

    <!-- Bootstrap -->
    <link href=<c:url value="resources/css/bootstrap.min.css" /> rel="stylesheet">    

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
  </head>
  <body>
	<div class="container-fluid">
		<div class="row">
			<div class="col-md-4">
				<h2>Insert your data</h2> 
			</div>
		</div>
		<div class="row">
			<div class="col-md-4">
				<form id="registrationForm" role="form" action="#" >
				  <div class="form-group">
					<label for="username">Username</label>
					<input type="text" class="form-control" id="username" name="username" placeholder="Username">
				  </div>
				  <div class="form-group">
					<label for="password">Password</label>
					<input type="password" class="form-control" id="password" name="password" placeholder="Password">
				  </div>
				  <div class="form-group">		
					<label for="firstName">First Name</label>
					<input type="text" class="form-control" id="firstName" name="firstName" placeholder="Enter your first name">
				  </div>
				  <div class="form-group">		
					<label for="lastName">Last Name</label>
					<input type="text" class="form-control" id="lastName" name="lastName" placeholder="Enter your last name">
				  </div>
				  <div class="form-group">		
					<label for="email">Email address</label>
					<input type="email" class="form-control" id="email" name="email" placeholder="Enter your email">
				  </div>
				  <div class="form-group">		
					<label for="phone">Phone</label>
					<input type="tel" class="form-control" id="phone"  name="phone" placeholder="Enter phone">
				  </div>
				  <button type="submit" class="btn btn-default">Submit</button>
				</form>
			</div>
		</div>
		<!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
		<script src=<c:url value="resources/js/jquery.js" />></script>
		<script src=<c:url value="resources/js/bootstrap.min.js" />></script>
		<script src=<c:url value="resources/js/application.js" />></script>		
	</div>
  </body>
</html>
