package com.adrom.chemxr_api.web;

import com.adrom.chemxr_api.dto.UserInfo;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Mono;

@RestController
public class UserController {

    @GetMapping("/user/me")
    public Mono<UserInfo> currentUser(@AuthenticationPrincipal OAuth2User principal) {
        if (principal == null) {
            return Mono.empty();
        }
        return Mono.just(new UserInfo(
                principal.getAttributes().get("email"),
                principal.getAttributes().get("name"),
                principal.getAttributes().get("picture"),
                principal.getAuthorities().stream()
                        .map(a -> a.getAuthority())
                        .toList()
        ));
    }
}
