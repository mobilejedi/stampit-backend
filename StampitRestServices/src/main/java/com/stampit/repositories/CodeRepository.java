package com.stampit.repositories;

import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import com.stampit.model.Code;


@RepositoryRestResource(collectionResourceRel ="code", path="codes")
public interface CodeRepository extends PagingAndSortingRepository<Code, Long> {
	public Code findByCode(String code);
}


