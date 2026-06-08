package com.adrom.chemxr_api;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest(properties = {
		"spring.security.oauth2.client.registration.google.client-id=test",
		"spring.security.oauth2.client.registration.google.client-secret=test",
		"spring.security.oauth2.client.registration.facebook.client-id=test",
		"spring.security.oauth2.client.registration.facebook.client-secret=test"
})
class ChemxrApiApplicationTests {

	@Test
	void contextLoads() {
	}

}
