package com.stampit.repositories;

import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

import com.stampit.model.CustomerConfirmation;

@RepositoryRestResource(collectionResourceRel ="customers_confirmations", path="customers_confirmations")
public interface CustomerConfirmationRepository extends PagingAndSortingRepository<CustomerConfirmation, Long>{
	
	public CustomerConfirmation findByIdCustomerAndConfirmationKey(Long customerId, String key);
	
}
