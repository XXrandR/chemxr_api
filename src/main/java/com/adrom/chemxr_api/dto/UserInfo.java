package com.adrom.chemxr_api.dto;

public record UserInfo(
        Object email,
        Object name,
        Object picture,
        java.util.List<String> roles
) {
}
