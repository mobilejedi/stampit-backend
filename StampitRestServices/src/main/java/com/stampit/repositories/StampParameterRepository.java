package com.stampit.repositories;

import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import com.stampit.model.StampParameter;

@RepositoryRestResource(collectionResourceRel ="stampParameter", path="stampParameters")
public interface StampParameterRepository extends PagingAndSortingRepository<StampParameter, Long> {
	
}


