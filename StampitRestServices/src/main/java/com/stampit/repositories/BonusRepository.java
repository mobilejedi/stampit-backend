package com.stampit.repositories;

import java.util.List;

import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

import com.stampit.model.Bonus;
import com.stampit.model.Card;

@RepositoryRestResource(collectionResourceRel ="bonus", path="bonuses")
public interface BonusRepository extends PagingAndSortingRepository<Bonus, Long> {
	public List<Bonus> findByCardOrderBySlotPosAsc(Card card); 
}


