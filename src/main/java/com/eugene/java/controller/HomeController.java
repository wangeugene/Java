package com.eugene.java.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HomeController {
  @GetMapping("/")
  public String home() {
    return "Hello, Home!";
  }

  /**
   * request URL: http://localhost:8080/url-encoded/wang%20eugene response: Hello, wang eugene!
   *
   * @param name
   * @return
   */
  @GetMapping("/url-encoded/{name}")
  public String urlEncoded(@PathVariable String name) {
    return "Hello, " + name + "!";
  }
}
