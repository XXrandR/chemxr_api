package com.adrom.chemxr_api.repository;

import com.adrom.chemxr_api.domain.Users;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import reactor.core.publisher.Mono;

import java.util.UUID;

public interface UsersRepository extends ReactiveCrudRepository<Users, UUID> {

    Mono<Boolean> existsByEmail(String email);

    Mono<Boolean> existsByUsername(String username);

    Mono<Users> findByUsername(String username);

    Mono<Users> findByEmail(String email);
}