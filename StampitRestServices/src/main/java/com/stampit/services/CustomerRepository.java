package com.stampit.services;

import java.util.List;

import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

import com.stampit.model.Customer;

@RepositoryRestResource(collectionResourceRel ="customer", path="customers")
public interface CustomerRepository extends PagingAndSortingRepository<Customer, Long> {
	List<Customer> findByLastName(@Param("lastName") String lastName);
}


