package com.adrom.chemxr_api.service;

import com.adrom.chemxr_api.domain.People;
import com.adrom.chemxr_api.domain.Users;
import com.adrom.chemxr_api.dto.LoginRequest;
import com.adrom.chemxr_api.dto.LoginResponse;
import com.adrom.chemxr_api.exception.ApiException;
import com.adrom.chemxr_api.repository.PeopleRepository;
import com.adrom.chemxr_api.repository.UsersRepository;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Mono;

@Service
public class LoginService {

    private final UsersRepository usersRepository;
    private final PeopleRepository peopleRepository;
    private final PasswordEncoder passwordEncoder;

    public LoginService(
            UsersRepository usersRepository,
            PeopleRepository peopleRepository,
            PasswordEncoder passwordEncoder
    ) {
        this.usersRepository = usersRepository;
        this.peopleRepository = peopleRepository;
        this.passwordEncoder = passwordEncoder;
    }

    public Mono<LoginResponse> login(LoginRequest request) {
        String identifier = request.getUsername() == null ? "" : request.getUsername().trim();
        String password = request.getPassword() == null ? "" : request.getPassword();

        if (identifier.isEmpty() || password.isEmpty()) {
            return Mono.error(new ApiException(HttpStatus.BAD_REQUEST, "Ingresa usuario/contraseña"));
        }

        Mono<Users> byUsername = usersRepository.findByUsername(identifier);
        Mono<Users> byEmail = usersRepository.findByEmail(identifier);

        return byUsername.switchIfEmpty(byEmail)
                .switchIfEmpty(Mono.error(new ApiException(HttpStatus.UNAUTHORIZED, "Usuario o contraseña incorrectos")))
                .flatMap(user -> {
                    if (!passwordEncoder.matches(password, user.getPasswordHash())) {
                        return Mono.error(new ApiException(HttpStatus.UNAUTHORIZED, "Usuario o contraseña incorrectos"));
                    }
                    if (!Boolean.TRUE.equals(user.getIsActive())) {
                        return Mono.error(new ApiException(HttpStatus.FORBIDDEN, "Usuario bloqueado o inactivo"));
                    }
                    return peopleRepository.findById(user.getPersonId())
                            .map(person -> toResponse(user, person))
                            .defaultIfEmpty(toResponse(user, null));
                });
    }

    private LoginResponse toResponse(Users user, People person) {
        String firstName = person != null ? person.getFirstName() : null;
        String lastName = person != null ? person.getLastName() : null;
        String displayName = person != null && person.getFullName() != null
                ? person.getFullName()
                : user.getDisplayName();
        return new LoginResponse(
                user.getId(),
                user.getUsername(),
                user.getEmail(),
                displayName,
                firstName,
                lastName
        );
    }
}