package com.adrom.chemxr_api.dto;

import java.util.UUID;

public class RegisterResponse {

    private UUID id;
    private String username;
    private String email;
    private String status;

    public RegisterResponse() {
    }

    public RegisterResponse(UUID id, String username, String email, String status) {
        this.id = id;
        this.username = username;
        this.email = email;
        this.status = status;
    }

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}