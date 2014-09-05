package com.stampit.repositories;

import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import com.stampit.model.MerchantCategory;

@RepositoryRestResource(collectionResourceRel ="merchantCategory", path="merchantCategories")
public interface MerchantCategoryRepository extends PagingAndSortingRepository<MerchantCategory, Long> {
}


