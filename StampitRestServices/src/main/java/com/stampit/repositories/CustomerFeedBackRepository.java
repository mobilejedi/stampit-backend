package com.stampit.repositories;

import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import com.stampit.model.CustomerFeedback;

@RepositoryRestResource(collectionResourceRel ="customerFeedback", path="customerFeedbacks")
public interface CustomerFeedBackRepository extends PagingAndSortingRepository<CustomerFeedback, Long> {
}


