package com.eugene.fart

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication

@SpringBootApplication
class FartApplication

fun main(args: Array<String>) {
	runApplication<FartApplication>(*args)
}
