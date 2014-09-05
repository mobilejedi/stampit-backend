package com.stampit.repositories;

import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import com.stampit.model.Prize;

@RepositoryRestResource(collectionResourceRel ="prize", path="prizes")
public interface MerchantFeedbackRepository extends PagingAndSortingRepository<Prize, Long> {
}


