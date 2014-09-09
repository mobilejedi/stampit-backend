package com.stampit.controller;

import java.io.IOException;
import java.security.Security;
import java.util.Date;
import java.util.Properties;
import java.util.UUID;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import javax.annotation.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
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
	@Resource(name="mailProperties")	
	private Properties mailProperties;
	@Resource(name="properties")	
	private Properties properties;
	
	@RequestMapping(value = "/registerCustomer", method = RequestMethod.POST,  consumes = "application/json")
	public ResponseEntity<String> registerUser(@RequestBody String customer, HttpServletRequest request) {
		logger.info("customer" + customer);
		String baseUrl = String.format("%s://%s:%d/",request.getScheme(),  request.getServerName(), request.getServerPort());
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
		String customersUrl = baseUrl + "StampitRestServices/rest/customers";
		String content = null;
		try {
			content = restTemplate.postForObject(customersUrl, customerObject, String.class);		
		} catch(RestClientException ex) {
			return new ResponseEntity<String>(null, new HttpHeaders(), HttpStatus.UNPROCESSABLE_ENTITY);
		}
		CustomerConfirmation confirmation = null;
		ResponseEntity<String> response = null;
		try {
			confirmation = this.generateConfirmationKey(customerObject.getUsername());
			this.sendConfirmationEmail(customerObject.getEmail(), confirmation, request);
		} catch(Exception ex) {
			customerRepository.delete(confirmation.getIdCustomer());
			ex.printStackTrace();
			response =  new ResponseEntity<String>(null, new HttpHeaders(), HttpStatus.UNPROCESSABLE_ENTITY);
			return response;
		}
		response =  new ResponseEntity<String>(content, new HttpHeaders(), HttpStatus.CREATED);
		customerConfirmationRepository.save(confirmation);
		return response;
	}
	
	private void sendConfirmationEmail(String email, CustomerConfirmation customerConfirmation, HttpServletRequest request) throws AddressException, MessagingException {
		String baseUrl = String.format("%s://%s:%d/",request.getScheme(),  request.getServerName(), request.getServerPort());
		String confirmationUrl = baseUrl + "validateConfirmationKey/" + customerConfirmation.getIdCustomer() + "&" + customerConfirmation.getConfirmationKey();
		logger.info("confirmationUrl: " + confirmationUrl);
		Security.addProvider(new com.sun.net.ssl.internal.ssl.Provider());
        //final String SSL_FACTORY = "javax.net.ssl.SSLSocketFactory";        
//      props.setProperty("proxySet","true");
//      props.setProperty("socksProxyHost","10.182.146.152");
//      props.setProperty("socksProxyPort","80");
//        props.setProperty("mail.smtp.host", "smtp.gmail.com");
//        props.setProperty("mail.smtp.socketFactory.class", SSL_FACTORY);
//        props.setProperty("mail.smtp.socketFactory.fallback", "false");
//        props.setProperty("mail.smtp.port", "465");
//        props.setProperty("mail.smtp.socketFactory.port", "465");
//        props.put("mail.smtp.auth", "true");
//        props.put("mail.debug", "true");
//        props.put("mail.store.protocol", "imap");
//        props.put("mail.transport.protocol", "smtp");
        final String username = properties.getProperty("mail.username");
        final String password = properties.getProperty("mail.password");
        Session session = Session.getDefaultInstance(mailProperties, 
                             new Authenticator(){
                                protected PasswordAuthentication getPasswordAuthentication() {
                                   return new PasswordAuthentication(username, password);
                                }
                             });
        Message msg = new MimeMessage(session);    
        msg.setFrom(new InternetAddress(username));		
	    msg.setRecipients(Message.RecipientType.TO, 
	                         InternetAddress.parse(email, false));
	    msg.setSubject("Welcome in StampIt");
	    msg.setText("Please confirm your e-mail clicking on the following url " +
	        		confirmationUrl);
	    msg.setSentDate(new Date());
	        Transport.send(msg);               
        logger.info("Message sent.");
	}
	
	private CustomerConfirmation generateConfirmationKey(String username) {
		String confirmationKey = UUID.randomUUID().toString();
		logger.info("UUID" + confirmationKey.toString());
		Customer customer = customerRepository.findByUsername(username);
		CustomerConfirmation confirmation = new CustomerConfirmation();
		confirmation.setIdCustomer(customer.getIdCustomer());
		confirmation.setConfirmationKey(confirmationKey);
		confirmation.setConfirmed(false);		
		return confirmation;
	}
}
