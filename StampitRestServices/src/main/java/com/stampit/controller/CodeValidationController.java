package com.stampit.controller;

import java.util.Date;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.repository.support.Repositories;
import org.springframework.hateoas.ResourceSupport;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;

import static org.springframework.hateoas.mvc.ControllerLinkBuilder.*;

import com.stampit.model.AchievedBonus;
import com.stampit.model.ActiveCard;
import com.stampit.model.Bonus;
import com.stampit.model.Card;
import com.stampit.model.Code;
import com.stampit.model.Customer;
import com.stampit.model.Log;
import com.stampit.model.Merchant;
import com.stampit.repositories.AchievedBonusRepository;
import com.stampit.repositories.ActiveCardRepository;
import com.stampit.repositories.BonusRepository;
import com.stampit.repositories.CardRepository;
import com.stampit.repositories.CodeRepository;
import com.stampit.repositories.CustomerRepository;
import com.stampit.repositories.LogRepository;
import com.stampit.repositories.MerchantRepository;

@RestController
public class CodeValidationController {	
	
	private static final Logger logger = LoggerFactory.getLogger(CodeValidationController.class);
	
	@Autowired private CodeRepository codeRepository;
	@Autowired private ActiveCardRepository activeCardRepository;
	@Autowired private CustomerRepository customerRepository;
	@Autowired private BonusRepository bonusRepository;
	@Autowired private AchievedBonusRepository achievedBonusRepository;
	@Autowired private LogRepository logRepository;	
	@Autowired private MerchantRepository merchantRepository;
	
	@RequestMapping("/validateCode")
	public ResponseEntity<String> validateCodeAssignBonus(@RequestParam(value="idCustomer", required=true)Long idCustomer,  @RequestParam(value="code", required=true)String code) {		
		Code codeObject = codeRepository.findByCode(code);
		if(codeObject == null) {
			return new ResponseEntity<String>(HttpStatus.NOT_FOUND);
		}
		Card codeCard = codeObject.getCard();
		Customer codeCustomer = customerRepository.findOne(idCustomer);
		ActiveCard codeActiveCard = activeCardRepository.findByCardAndCustomerAndStampsNumberNot(codeCard, codeCustomer, codeCard.getSlotsNum());
		int stampsToAdd = codeObject.getStampParameters().getStampsNum();
		if(codeActiveCard == null || codeActiveCard.getStampsNumber() == codeCard.getSlotsNum()) {
			codeActiveCard = new ActiveCard();
			codeActiveCard.setCard(codeCard);			
			codeActiveCard.setCustomer(codeCustomer);					
		}
		int updatedStampsNumber = codeActiveCard.getStampsNumber() + stampsToAdd;
		ResponseEntity<String> response = null;
		if(updatedStampsNumber > codeCard.getSlotsNum()) {
//			ActiveCard codeNewActiveCard = new ActiveCard();
//			codeNewActiveCard.setCard(codeCard);			
//			codeNewActiveCard.setCustomer(codeCustomer);
//			codeNewActiveCard.setStampsNumber(updatedStampsNumber - codeCard.getSlotsNum());
			codeActiveCard.setStampsNumber(codeCard.getSlotsNum());
			activeCardRepository.save(codeActiveCard);
//			activeCardRepository.save(codeNewActiveCard);
//			RestTemplate restTemplate = new RestTemplate();
//			String codeActiveCardUrl = "http://localhost:8080/StampitRestServices-0.0.1-SNAPSHOT/rest/activeCards/{idCard}";
//			String content= restTemplate.getForObject(codeActiveCardUrl, String.class, codeNewActiveCard.getIdActiveCard());		
//			ResponseEntity<String> response =  new ResponseEntity<String>(content, new HttpHeaders(), HttpStatus.OK);
//			String content= restTemplate.getForObject(codeActiveCardUrl, String.class, codeActiveCard.getIdActiveCard());		
//			response =  new ResponseEntity<String>(content, new HttpHeaders(), HttpStatus.OK);
//			this.updateAchievedBonuses(codeActiveCard);
//			this.updateLogs(codeActiveCard, stampsToAdd);			
		} else {
			codeActiveCard.setStampsNumber(updatedStampsNumber);
			activeCardRepository.save(codeActiveCard);
						
		}
		RestTemplate restTemplate = new RestTemplate();
		String codeActiveCardUrl = "http://localhost:8080/StampitRestServices-0.0.1-SNAPSHOT/rest/activeCards/{idCard}";
		String content= restTemplate.getForObject(codeActiveCardUrl, String.class, codeActiveCard.getIdActiveCard());		
		response =  new ResponseEntity<String>(content, new HttpHeaders(), HttpStatus.OK);
		this.updateAchievedBonuses(codeActiveCard);
		this.updateLogs(codeActiveCard, stampsToAdd);
		return response;
		
	}
	
	private void updateAchievedBonuses(ActiveCard activeCard) {
		List<Bonus> bonusList = bonusRepository.findByCardOrderBySlotPosAsc(activeCard.getCard());
		logger.info("bonusList size: " + bonusList.size());
		List<AchievedBonus> achievedBonusList = achievedBonusRepository.findByActiveCard(activeCard);
		for(Bonus currentBonus: bonusList) {
			boolean alreadyPresent = false;
			for(AchievedBonus currentAchievedBonus: achievedBonusList) {				
				if(currentBonus.getIdBonus() == currentAchievedBonus.getBonus().getIdBonus()) {
					alreadyPresent = true;
					break;
				}				
			}
			if(!alreadyPresent) {
				if(activeCard.getStampsNumber() >= currentBonus.getSlotPos()) {
					logger.info("activeCard stamps number: " + activeCard.getStampsNumber());
					logger.info("currentBonus slots number: " + currentBonus.getSlotPos());
					AchievedBonus newAchievedBonus = new AchievedBonus();
					newAchievedBonus.setActiveCard(activeCard);
					newAchievedBonus.setBonus(currentBonus);
					achievedBonusRepository.save(newAchievedBonus);					
				}
			}
		}
	}
	
	public void updateLogs(ActiveCard activeCard, int addedStamps) {
		Log newLog = new Log();
		newLog.setActiveCard(activeCard);
		newLog.setStampsNum(addedStamps);
		newLog.setInsDate(new Date());
		Merchant activeCardMerchant = merchantRepository.findMerchantByActiveCard(activeCard);
		newLog.setLocation(activeCardMerchant.getGpsCoordinates());
		logRepository.save(newLog);
	}

}
