package com.stampit.repositories;

import java.util.List;

import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

import com.stampit.model.AchievedBonus;
import com.stampit.model.ActiveCard;

@RepositoryRestResource(collectionResourceRel ="achievedBonus", path="achievedBonuses")
public interface AchievedBonusRepository extends PagingAndSortingRepository<AchievedBonus, Long> {
	public List<AchievedBonus> findByActiveCard(ActiveCard activeCard);
}


