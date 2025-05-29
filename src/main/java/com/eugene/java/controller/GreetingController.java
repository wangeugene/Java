package com.eugene.java.controller;

import java.util.concurrent.atomic.AtomicLong;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.eugene.java.model.Greeting;

@RestController
public class GreetingController {
  private static final String template = "Hello, %s!";
  private final AtomicLong counter = new AtomicLong();

  /**
   * This endpoint is not used by default * , this endpoint is accessible from any origin. If you
   * want to restrict access to specific origins, you can use the @CrossOrigin annotation. to start
   * this application, with application.properties config to server.port=9000 the Spring Boot
   * application will run on port 9000 locally to access this endpoint, use the following URL: -
   * http://localhost:8080/greeting?name=eugene
   *
   * @param name
   * @return
   */
  @CrossOrigin(origins = "http://localhost:9000")
  @GetMapping("/greeting")
  public Greeting greeting(@RequestParam(required = false, defaultValue = "World") String name) {
    System.out.println("==== get greeting ====");
    return new Greeting(counter.incrementAndGet(), String.format(template, name));
  }
}
