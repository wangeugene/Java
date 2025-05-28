package com.eugene.Java.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HomeController {
    @GetMapping("/")
    public String home() {
        return "Hello, Home!";
    }

    @GetMapping("/url-encoded/{name}")
    public String urlEncoded(@PathVariable String name) {
        return "Hello, " + name + "!";
    }
}
