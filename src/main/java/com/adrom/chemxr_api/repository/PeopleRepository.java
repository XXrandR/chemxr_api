package com.adrom.chemxr_api.repository;

import com.adrom.chemxr_api.domain.People;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;

import java.util.UUID;

public interface PeopleRepository extends ReactiveCrudRepository<People, UUID> {
}