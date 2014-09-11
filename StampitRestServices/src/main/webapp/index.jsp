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
	<link href=<c:url value="resources/css/my.css" /> rel="stylesheet">
    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
  </head>
  <body>
  	
  	<!-- Navbar -->
	<nav class="navbar navbar-default" role="navigation">
	  <div class="container-fluid">
		<!-- Brand and toggle get grouped for better mobile display -->
		<div class="navbar-header">
		  <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
			<span class="sr-only">Toggle navigation</span>
			<span class="icon-bar"></span>
			<span class="icon-bar"></span>
			<span class="icon-bar"></span>
		  </button>
		  <a class="navbar-brand" href="#">StampIt(Change my name)</a>
		</div>

		<!-- Collect the nav links, forms, and other content for toggling -->
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
		  <ul class="nav navbar-nav">
			
		  </ul>
		  <form class="navbar-form navbar-left" role="search">
			<div class="form-group">
			  
			</div>			
		  </form>
		  <ul class="nav navbar-nav navbar-right">
			
		  </ul>
		</div><!-- /.navbar-collapse -->
	  </div><!-- /.container-fluid -->
	</nav>
  	
  	<!-- Main content -->
	<div class="container-fluid">
		<div class="row">
			<div class="col-md-4 col-md-offset-4">
				<h2>Insert your data</h2> 
			</div>
		</div>
		<div class="row">
			<div class="col-md-4 col-md-offset-4">
				<form id="registrationForm" role="form" action="#" >
				  <div id="successMessage" class="alert alert-success hide" role="alert">Please check your e-mail to complete the registration process.</div>
				  <div id="errorMessage" class="alert alert-danger hide" role="alert"></div>
				  
				  <div class="form-group">
					<label for="username">Username</label>
					<input required pattern=".{0,16}" title="16 characters maximum" type="text" class="form-control" id="username" name="username" placeholder="Enter username">
				  </div>
				  <div class="form-group">
					<label for="password">Password</label>
					<input required pattern=".{6,50}" title="6 characters minimum, 50 characters maximum" type="password" class="form-control" id="password" name="password" placeholder="Enter password">
				  </div>
				  <div class="form-group">		
					<label for="firstName">First Name</label>
					<input required pattern=".{0,45}" title="45 characters maximum" type="text" class="form-control" id="firstName" name="firstName" placeholder="Enter your first name">
				  </div>
				  <div class="form-group">		
					<label for="lastName">Last Name</label>
					<input required pattern=".{0,45}" title="45 characters maximum" type="text" class="form-control" id="lastName" name="lastName" placeholder="Enter your last name">
				  </div>
				  <div class="form-group">		
					<label for="email">Email address</label>
					<input required required pattern=".{0,45}" title="45 characters maximum" type="email" class="form-control" id="email" name="email" placeholder="Enter your email">
				  </div>
				  <div class="form-group">		
					<label for="phone">Phone</label>
					<input required required pattern=".{0,45}" title="45 characters maximum" type="tel" class="form-control" id="phone"  name="phone" placeholder="Enter phone">
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
