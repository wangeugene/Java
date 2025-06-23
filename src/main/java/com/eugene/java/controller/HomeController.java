package com.eugene.java.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HomeController {

  /**
   * request URL: <a href="http://localhost:8080/url-encoded/wang%20eugene">...</a> response: Hello,
   * wang eugene!
   */
  @GetMapping("/url-encoded/{name}")
  public String urlEncoded(@PathVariable String name) {
    return "Hello, " + name + "!";
  }
}
