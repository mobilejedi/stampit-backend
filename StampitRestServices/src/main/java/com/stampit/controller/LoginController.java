/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.stampit.controller;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.stampit.model.Customer;
import com.stampit.model.CustomerConfirmation;
import com.stampit.repositories.CustomerConfirmationRepository;
import com.stampit.repositories.CustomerRepository;
import java.io.IOException;
import java.util.logging.Level;
import javax.servlet.http.HttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class LoginController {
    
    private static final Logger logger = LoggerFactory.getLogger(LoginController.class);    
    @Autowired
    private CustomerRepository customerRepository;
    @Autowired
    private CustomerConfirmationRepository customerConfirmationRepository;
    
    @RequestMapping(value = "/authenticateCustomer", method = RequestMethod.POST,  consumes = "application/json")
    public ResponseEntity<String> authenticateUser(@RequestBody String authInfo, HttpServletRequest request) throws IOException {        
        ObjectMapper objectMapper = new ObjectMapper();
        AuthInfo authInfoObject = null;		
        authInfoObject = objectMapper.readValue(authInfo, AuthInfo.class);
        Customer customer = customerRepository.findByUsernameAndPassword(authInfoObject.getUsername(), authInfoObject.getPassword());
        ResponseEntity<String> response = null;
        if(customer == null) {
            response = new ResponseEntity<String>(null, new HttpHeaders(), HttpStatus.UNAUTHORIZED);
        } else {
            CustomerConfirmation confirmation = customerConfirmationRepository.findOne(customer.getIdCustomer());
            if(confirmation.getConfirmed()) {
                response = new ResponseEntity<String>("{\"id\":\"" + customer.getIdCustomer() + "\"}" , new HttpHeaders(), HttpStatus.OK);
            } else {
                response = new ResponseEntity<String>(null, new HttpHeaders(), HttpStatus.UNAUTHORIZED);
            }
        }
        return response;        
    }
    
    public static class AuthInfo {
        
        private String username;
        private String password;
        
        public String getUsername() {
            return username;
        }
        
        public void setUsername(String username) {
            this.username = username;
        }
        
        public String getPassword() {
            return password;
        }
        
        public void setPassword(String password) {
            this.password = password;
        }
    }
}
