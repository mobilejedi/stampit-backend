package com.stampit.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.converter.json.MappingJacksonHttpMessageConverter;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.stampit.model.Customer;
import com.stampit.model.CustomerConfirmation;
import com.stampit.repositories.CustomerConfirmationRepository;
import com.stampit.repositories.CustomerRepository;

@RestController
public class RegistrationController {
	
	private static final Logger logger = LoggerFactory.getLogger(RegistrationController.class);
	@Autowired private CustomerConfirmationRepository customerConfirmationRepository;
	@Autowired private CustomerRepository customerRepository;
	
	@RequestMapping(value = "/registerCustomer", method = RequestMethod.POST,  consumes = "application/json")
	public ResponseEntity<String> registerUser(@RequestBody String customer) {
		logger.info("customer" + customer);
		ObjectMapper objectMapper = new ObjectMapper();
		Customer customerObject = null;		
		try {
			customerObject = objectMapper.readValue(customer, Customer.class);
		} catch (JsonParseException e) {
			e.printStackTrace();
		} catch (JsonMappingException e) {			
			e.printStackTrace();
		} catch (IOException e) {			
			e.printStackTrace();
		}
		logger.info(customerObject.toString());
		RestTemplate restTemplate = new RestTemplate();
		String customersUrl = "http://localhost:8080/StampitRestServices-0.0.1-SNAPSHOT/rest/customers";
		String content = null;
		try {
			content = restTemplate.postForObject(customersUrl, customerObject, String.class);		
		} catch(RestClientException ex) {
			return new ResponseEntity<String>(null, new HttpHeaders(), HttpStatus.UNPROCESSABLE_ENTITY);
		}
		String confirmationKey = this.generateConfirmationKey(customerObject.getUsername());
		this.sendConfirmationEmail(customerObject.getEmail(), confirmationKey);
		ResponseEntity<String> response =  new ResponseEntity<String>(content, new HttpHeaders(), HttpStatus.CREATED);
		return response;
	}
	
	private void sendConfirmationEmail(String email, String confirmationKey) {
		String confirmationUrl = "/validateConfirmationKey/" + confirmationKey;
		//TODO
	}
	
	private String generateConfirmationKey(String username) {
		String confirmationKey = UUID.randomUUID().toString();
		logger.info("UUID" + confirmationKey.toString());
		Customer customer = customerRepository.findByUsername(username);
		CustomerConfirmation confirmation = new CustomerConfirmation();
		confirmation.setIdCustomer(customer.getIdCustomer());
		confirmation.setConfirmationKey(confirmationKey);
		confirmation.setConfirmed(false);
		customerConfirmationRepository.save(confirmation);
		return customer.getIdCustomer() + "&" + confirmationKey;
	}
}
