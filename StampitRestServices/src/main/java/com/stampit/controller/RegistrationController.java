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
import org.springframework.beans.factory.annotation.Value;
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
	
	@Value("#{mailProperties['mail.smtp.host']}")
	private String mailSmtpHost;
	@Value("#{mailProperties['mail.smtp.socketFactory.class']}")
	private String mailSmtpSocketFactoryClass;
	@Value("#{mailProperties['mail.smtp.socketFactory.fallback']}")
	private String mailSmtpSocketFactoryFallback;
	@Value("#{mailProperties['mail.smtp.port']}")
	private String mailSmtpPort;
	@Value("#{mailProperties['mail.smtp.socketFactory.port']}")
	private String mailSmtpSocketFactoryPort;
	@Value("#{mailProperties['mail.smtp.auth']}")
	private String mailSmtpAuth;
	@Value("#{mailProperties['mail.debug']}")
	private String mailDebug;
	@Value("#{mailProperties['mail.store.protocol']}")
	private String mailStoreProtocol;
	@Value("#{mailProperties['mail.transport.protocol']}")
	private String mailTransportProtocol;
	@Value("#{mailProperties['mail.username']}")
	private String username;
	@Value("#{mailProperties['mail.password']}")
	private String password;
	
	@RequestMapping(value = "/registerCustomer", method = RequestMethod.POST,  consumes = "application/json")
	public ResponseEntity<String> registerUser(@RequestBody String customer, HttpServletRequest request) {
		logger.info("customer" + customer);
		logger.info("Context path: " + request.getContextPath());
		String appUrl = String.format("%s://%s:%d/%s",request.getScheme(),  request.getServerName(), request.getServerPort(), request.getContextPath());
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
		String customersUrl = appUrl + "/rest/customers";
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
			response =  new ResponseEntity<String>(null, new HttpHeaders(), HttpStatus.REQUEST_TIMEOUT);
			return response;
		}
		response =  new ResponseEntity<String>(content, new HttpHeaders(), HttpStatus.CREATED);
		customerConfirmationRepository.save(confirmation);
		return response;
	}
	
	private void sendConfirmationEmail(String email, CustomerConfirmation customerConfirmation, HttpServletRequest request) throws AddressException, MessagingException {
		String appUrl = String.format("%s://%s:%d/%s",request.getScheme(),  request.getServerName(), request.getServerPort(), request.getContextPath());
		String confirmationUrl = appUrl + "/validateConfirmationKey/" + customerConfirmation.getIdCustomer() + "&" + customerConfirmation.getConfirmationKey();
		logger.info("confirmationUrl: " + confirmationUrl);
		Security.addProvider(new com.sun.net.ssl.internal.ssl.Provider());
        Properties props = new Properties();
        logger.info("mail.smtp.host: " + mailSmtpHost);
//		props.setProperty("mail.smtp.host", mailSmtpHost);
//        props.setProperty("mail.smtp.socketFactory.class", mailSmtpSocketFactoryClass);
//        props.setProperty("mail.smtp.socketFactory.fallback", mailSmtpSocketFactoryFallback);
//        props.setProperty("mail.smtp.port", mailSmtpPort);
//        props.setProperty("mail.smtp.socketFactory.port", mailSmtpSocketFactoryPort);
//        props.put("mail.smtp.auth", mailSmtpAuth);
//        props.put("mail.debug", mailDebug);
//        props.put("mail.store.protocol", mailStoreProtocol);
//        props.put("mail.transport.protocol", mailTransportProtocol);
        final String SSL_FACTORY = "javax.net.ssl.SSLSocketFactory";
        props.setProperty("mail.smtp.host", "smtp.gmail.com");
        props.setProperty("mail.smtp.socketFactory.class", SSL_FACTORY);
        props.setProperty("mail.smtp.socketFactory.fallback", "false");
        props.setProperty("mail.smtp.port", "465");
        props.setProperty("mail.smtp.socketFactory.port", "465");
        props.put("mail.smtp.auth", "true");
        props.put("mail.debug", "true");
        props.put("mail.store.protocol", "imap");
        props.put("mail.transport.protocol", "smtp");
        final String username = "stampit.test@gmail.com";
        final String password = "alten003";
        
        logger.info("username: " + username);
        logger.info("password: " + password);
        
        Session session = Session.getDefaultInstance(props, 
                             new Authenticator(){
                                protected PasswordAuthentication getPasswordAuthentication() {
                                   return new PasswordAuthentication(username, password);
                                }
                             });
        logger.info("Session: " + session);
        Message msg = new MimeMessage(session);    
        msg.setFrom(new InternetAddress(username));		
	    msg.setRecipients(Message.RecipientType.TO, 
	                         InternetAddress.parse(email, false));
	    msg.setSubject("Welcome to StampIt");
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
