package com.adrom.chemxr_api.repository;

import com.adrom.chemxr_api.domain.Registrations;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;

import java.util.UUID;

public interface RegistrationsRepository extends ReactiveCrudRepository<Registrations, UUID> {
}