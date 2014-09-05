package com.stampit.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.PathVariable;

import com.stampit.model.CustomerConfirmation;
import com.stampit.repositories.CustomerConfirmationRepository;

@Controller
public class ConfirmationController {
	
	@Autowired private CustomerConfirmationRepository customerConfirmationRepository;
	
	@RequestMapping("/validateConfirmationKey/{idCustomer}&{key}")
	public String validateConfirmationKey(@PathVariable("idCustomer") Long idCustomer, @PathVariable("key")String key) {
		CustomerConfirmation customerConfirmation = customerConfirmationRepository.findByIdCustomerAndConfirmationKey(idCustomer, key);
		if(customerConfirmation != null) {
			customerConfirmation.setConfirmed(true);
			customerConfirmationRepository.save(customerConfirmation);
			return "confirmation_ok";
		} else {
			return "confirmation_ko";
		}
	}
	
}
