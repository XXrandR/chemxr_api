package com.adrom.chemxr_api.service;

import com.adrom.chemxr_api.domain.People;
import com.adrom.chemxr_api.domain.Registrations;
import com.adrom.chemxr_api.domain.Users;
import com.adrom.chemxr_api.dto.RegisterRequest;
import com.adrom.chemxr_api.dto.RegisterResponse;
import com.adrom.chemxr_api.exception.ApiException;
import com.adrom.chemxr_api.repository.PeopleRepository;
import com.adrom.chemxr_api.repository.RegistrationsRepository;
import com.adrom.chemxr_api.repository.UsersRepository;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import reactor.core.publisher.Mono;

import java.time.OffsetDateTime;
import java.util.UUID;

@Service
public class RegisterService {

    private static final String STATUS_APPROVED = "APPROVED";

    private final PeopleRepository peopleRepository;
    private final UsersRepository usersRepository;
    private final RegistrationsRepository registrationsRepository;
    private final PasswordEncoder passwordEncoder;

    public RegisterService(
            PeopleRepository peopleRepository,
            UsersRepository usersRepository,
            RegistrationsRepository registrationsRepository,
            PasswordEncoder passwordEncoder
    ) {
        this.peopleRepository = peopleRepository;
        this.usersRepository = usersRepository;
        this.registrationsRepository = registrationsRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Transactional
    public Mono<RegisterResponse> register(RegisterRequest request) {
        String username = request.getUsername() == null ? "" : request.getUsername().trim();
        String email = request.getEmail() == null ? "" : request.getEmail().trim();
        String firstName = request.getFirstName() == null ? "" : request.getFirstName().trim();
        String lastName = request.getLastName() == null ? "" : request.getLastName().trim();

        if (username.isEmpty() || email.isEmpty() || firstName.isEmpty()
                || lastName.isEmpty() || request.getPassword() == null) {
            return Mono.error(new ApiException(HttpStatus.BAD_REQUEST, "Todos los campos son obligatorios"));
        }

        return usersRepository.existsByEmail(email)
                .flatMap(emailExists -> {
                    if (emailExists) {
                        return Mono.error(new ApiException(HttpStatus.CONFLICT, "El correo ya está registrado"));
                    }
                    return usersRepository.existsByUsername(username).flatMap(usernameExists -> {
                        if (usernameExists) {
                            return Mono.error(new ApiException(HttpStatus.CONFLICT, "El usuario ya está registrado"));
                        }
                        return createUser(request, username, email, firstName, lastName);
                    });
                });
    }

    private Mono<RegisterResponse> createUser(
            RegisterRequest request,
            String username,
            String email,
            String firstName,
            String lastName
    ) {
        OffsetDateTime now = OffsetDateTime.now();
        String fullName = firstName + " " + lastName;

        People person = new People();
        person.setId(UUID.randomUUID());
        person.setFullName(fullName);
        person.setFirstName(firstName);
        person.setLastName(lastName);
        person.setIsActive(true);
        person.setCreatedAt(now);

        return peopleRepository.save(person)
                .flatMap(savedPerson -> {
                    Users user = new Users();
                    user.setId(UUID.randomUUID());
                    user.setPersonId(savedPerson.getId());
                    user.setUsername(username);
                    user.setDisplayName(fullName);
                    user.setPasswordHash(passwordEncoder.encode(request.getPassword()));
                    user.setEmail(email);
                    user.setPhone(request.getPhone());
                    user.setIsActive(true);
                    user.setIsBlocked(false);
                    user.setPasswordUpdatedAt(now);
                    user.setCreatedAt(now);

                    return usersRepository.save(user)
                            .flatMap(savedUser -> {
                                Registrations registration = new Registrations();
                                registration.setId(UUID.randomUUID());
                                registration.setPersonId(savedPerson.getId());
                                registration.setUserId(savedUser.getId());
                                registration.setUsername(savedUser.getUsername());
                                registration.setEmail(savedUser.getEmail());
                                registration.setPhone(savedUser.getPhone());
                                registration.setFirstName(firstName);
                                registration.setLastName(lastName);
                                registration.setStatus(STATUS_APPROVED);
                                registration.setProcessedAt(now);
                                registration.setCreatedAt(now);

                                return registrationsRepository.save(registration)
                                        .map(savedRegistration ->
                                                new RegisterResponse(
                                                        savedUser.getId(),
                                                        savedUser.getUsername(),
                                                        savedUser.getEmail(),
                                                        savedRegistration.getStatus()
                                                )
                                        );
                            });
                });
    }
}