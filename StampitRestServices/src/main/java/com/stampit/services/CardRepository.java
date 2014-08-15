package com.stampit.services;

import java.util.List;

import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

import com.stampit.model.AchievedBonus;
import com.stampit.model.ActiveCard;
import com.stampit.model.Card;
import com.stampit.model.Customer;

@RepositoryRestResource(collectionResourceRel ="card", path="cards")
public interface CardRepository extends PagingAndSortingRepository<Card, Long> {
}


