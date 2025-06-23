package com.eugene.java.integration;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.net.URI;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.annotation.Import;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.web.servlet.MockMvc;

import com.eugene.java.config.TestSecurityConfig;

/**
 * Bean Definition Conflict: There was a conflict between SecurityConfig and TestSecurityConfig as
 * both were defining a bean with the same name (securityFilterChain).
 *
 * <p>Solution Applied:
 *
 * <p>Added @TestPropertySource(properties = {"spring.main.allow-bean-definition-overriding=true"})
 * to allow bean overriding in the test context. Specified webEnvironment =
 * SpringBootTest.WebEnvironment.MOCK for clarity in the @SpringBootTest annotation. Test
 * Environment: The test is now configured properly to use the test security configuration while
 * allowing bean definition overriding, which is needed because the application's main security
 * configuration is still loaded in a full Spring Boot test.
 */
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.MOCK)
@AutoConfigureMockMvc
@Import(TestSecurityConfig.class)
@TestPropertySource(properties = {"spring.main.allow-bean-definition-overriding=true"})
public class HomeControllerIT {
  @Autowired private MockMvc mockMvc;

  /**
   * Use URL.create to pass URL-encoded string to MockMvc to mimic real-world scenarios
   * http://localhost:8080/url-encoded/Eugene%20Wang
   *
   * @throws Exception
   */
  @Test
  @DisplayName("Returns personalized greeting for url-encoded endpoint with special characters")
  void returnsPersonalizedGreetingForUrlEncodedEndpointWithSpecialCharacters() throws Exception {
    mockMvc
        .perform(get(URI.create("/url-encoded/Eugene%20Wang")))
        .andExpect(status().isOk())
        .andExpect(content().string("Hello, Eugene Wang!"));
  }
}
