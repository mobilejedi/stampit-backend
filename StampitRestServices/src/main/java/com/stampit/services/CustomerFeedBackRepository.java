package com.stampit.services;

import java.util.List;

import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

import com.stampit.model.Customer;
import com.stampit.model.CustomerFeedback;

@RepositoryRestResource(collectionResourceRel ="customerFeedback", path="customerFeedbacks")
public interface CustomerFeedBackRepository extends PagingAndSortingRepository<CustomerFeedback, Long> {
}


