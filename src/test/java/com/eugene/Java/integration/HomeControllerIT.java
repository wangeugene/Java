package com.eugene.Java.integration;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.net.URI;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.web.servlet.MockMvc;

@SpringBootTest
@AutoConfigureMockMvc
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
