package com.eugene.java;

import org.springframework.boot.SpringApplication;

public class TestJavaApplication {

  public static void main(String[] args) {
    SpringApplication.from(JavaApplication::main).with(TestcontainersConfiguration.class).run(args);
  }
}
