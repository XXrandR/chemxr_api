package com.adrom.chemxr_api.domain;

import org.springframework.data.annotation.Id;
import org.springframework.data.domain.Persistable;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

import java.time.OffsetDateTime;
import java.util.UUID;

@Table("registrations")
public class Registrations implements Persistable<UUID> {

    @Id
    private UUID id;

    @Column("person_id")
    private UUID personId;

    @Column("user_id")
    private UUID userId;

    private String username;

    private String email;

    private String phone;

    @Column("first_name")
    private String firstName;

    @Column("last_name")
    private String lastName;

    private String status;

    @Column("created_at")
    private OffsetDateTime createdAt;

    @Column("processed_at")
    private OffsetDateTime processedAt;

    @Column("processed_by")
    private UUID processedBy;

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public UUID getPersonId() {
        return personId;
    }

    public void setPersonId(UUID personId) {
        this.personId = personId;
    }

    public UUID getUserId() {
        return userId;
    }

    public void setUserId(UUID userId) {
        this.userId = userId;
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

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
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

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public OffsetDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(OffsetDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public OffsetDateTime getProcessedAt() {
        return processedAt;
    }

    public void setProcessedAt(OffsetDateTime processedAt) {
        this.processedAt = processedAt;
    }

    public UUID getProcessedBy() {
        return processedBy;
    }

    public void setProcessedBy(UUID processedBy) {
        this.processedBy = processedBy;
    }

    @Override
    public boolean isNew() {
        return true;
    }
}