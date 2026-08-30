package com.adrom.chemxr_api.dto;

import java.util.UUID;

public class LoginResponse {

    private UUID id;
    private String username;
    private String email;
    private String displayName;
    private String firstName;
    private String lastName;

    public LoginResponse() {
    }

    public LoginResponse(UUID id, String username, String email, String displayName,
                         String firstName, String lastName) {
        this.id = id;
        this.username = username;
        this.email = email;
        this.displayName = displayName;
        this.firstName = firstName;
        this.lastName = lastName;
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

    public String getDisplayName() {
        return displayName;
    }

    public void setDisplayName(String displayName) {
        this.displayName = displayName;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }
}