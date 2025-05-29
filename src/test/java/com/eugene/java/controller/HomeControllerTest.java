package com.eugene.java.controller;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.net.URI;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.test.web.servlet.MockMvc;

@WebMvcTest(HomeController.class)
class HomeControllerTest {

  @Autowired private MockMvc mockMvc;

  @Test
  @DisplayName("Returns greeting for home endpoint")
  void returnsGreetingForHomeEndpoint() throws Exception {
    mockMvc
        .perform(get("/"))
        .andExpect(status().isOk())
        .andExpect(content().string("Hello, Home!"));
  }

  @Test
  @DisplayName("Returns personalized greeting for url-encoded endpoint with regular name")
  void returnsPersonalizedGreetingForUrlEncodedEndpointWithRegularName() throws Exception {
    mockMvc
        .perform(get("/url-encoded/Eugene"))
        .andExpect(status().isOk())
        .andExpect(content().string("Hello, Eugene!"));
  }

  @Test
  @DisplayName("Returns personalized greeting for url-encoded endpoint with special characters")
  void returnsPersonalizedGreetingForUrlEncodedEndpointWithSpecialCharacters() throws Exception {
    mockMvc
        .perform(get(URI.create("/url-encoded/Eugene%20Wang")))
        .andExpect(status().isOk())
        .andExpect(content().string("Hello, Eugene Wang!"));
  }

  @Test
  @DisplayName("Returns personalized greeting for url-encoded endpoint with empty name")
  void returnsPersonalizedGreetingForUrlEncodedEndpointWithEmptyName() throws Exception {
    mockMvc.perform(get("/url-encoded/")).andExpect(status().isNotFound());
  }
}
