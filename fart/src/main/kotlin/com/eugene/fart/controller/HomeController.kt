package com.eugene.fart.controller

import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RestController

@RestController("/")
class HomeController {
    @GetMapping("/")
    fun home(): String {
        return "Welcome to Fart!"
    }
}