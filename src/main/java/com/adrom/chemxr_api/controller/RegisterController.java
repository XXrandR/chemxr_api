package com.adrom.chemxr_api.controller;

import com.adrom.chemxr_api.dto.RegisterRequest;
import com.adrom.chemxr_api.dto.RegisterResponse;
import com.adrom.chemxr_api.service.RegisterService;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Mono;

@RestController
@RequestMapping("/auth")
public class RegisterController {

    private final RegisterService registerService;

    public RegisterController(RegisterService registerService) {
        this.registerService = registerService;
    }

    @PostMapping("/register")
    @ResponseStatus(HttpStatus.CREATED)
    public Mono<RegisterResponse> register(@RequestBody RegisterRequest request) {
        return registerService.register(request);
    }
}