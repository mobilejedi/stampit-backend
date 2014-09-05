package com.stampit.repositories;

import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import com.stampit.model.Card;

@RepositoryRestResource(collectionResourceRel ="card", path="cards")
public interface CardRepository extends PagingAndSortingRepository<Card, Long> {
	
}


