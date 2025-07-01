# Java App built with Java 21 and Spring Boot 3.5.0 with Gradle 8.14.2 with build.gradle.kts and pom.xml
Which means it supports both Gradle and Maven build systems.

## Traits
- Use Log4j2 for logging over Spring Boot's default logging: logback, so exclusion of logback is required in the build.gradle.kts file and pom.xml.
- Generate customized JWT for OAuth2.0 with Spring Security.


### log4j2 integration
- add `log4j2-spring.xml` to `src/main/resources` for configuration.
- add dependencies for Log4j2 in `build.gradle.kts` or `pom.xml`.
- exclude logback in `build.gradle.kts` or `pom.xml`.
- use `@Slf4j` annotation from Lombok for logging in your classes.

This is for demo purposes only, for other projects, I will opt for Spring Boot's default logging: logback.


### Build & Test & Run with Gradle and Maven

> Gradle
- run `gradle.sh`

> Maven
- run `maven.sh`
