package com.stampit.repositories;

import java.util.List;

import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import org.springframework.data.jpa.repository.Query;

import com.stampit.model.ActiveCard;
import com.stampit.model.Merchant;

import javax.persistence.*;

@RepositoryRestResource(collectionResourceRel ="merchant", path="merchants")
public interface MerchantRepository extends PagingAndSortingRepository<Merchant, Long> {
	@Query(value = "select m.*, st_distance(m.GPS_COORDINATES, geomFromText(:gpsCoordinates)) as calcDistance "
				+ "from merchants as m "
				+ "having calcDistance < :distance "
				+ "order by calcDistance asc", nativeQuery = true)
	List<Merchant> findByGpsCoordinates(@Param("gpsCoordinates")String gpsCoordinates, @Param("distance") float distance);
	
	@Query(value = "select m.* "
			+ "from merchants m,"
			+ "		cards c,"
			+ "	    active_cards a"
			+ " where  a.ID_ACTIVE_CARD=:activeCard"
			+ "	and a.ID_CARD = c.ID_CARD"
			+ "	and c.ID_MERCHANT = m.ID_MERCHANT", nativeQuery = true)
	public Merchant findMerchantByActiveCard(@Param("activeCard")ActiveCard activeCard);
}


