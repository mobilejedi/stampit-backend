package com.stampit.repositories;

import java.util.List;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import com.stampit.model.Customer;
import com.stampit.model.Log;

@RepositoryRestResource(collectionResourceRel ="log", path="logs")
public interface LogRepository extends PagingAndSortingRepository<Log, Long> {
	List<Log> findByActiveCardCustomerOrderByInsDateDesc(@Param("customer") Customer customer);
}


