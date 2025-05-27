# A Kotlin-based and Gradle-based Spring Boot MVC application

## To run the application
- set up `jenv` to use the correct java version
- it uses `zsh`
- bootstrapped by the web app `Spring Initializr`

### Major dependencies
- JDK 21.0.7
- Gradle 8.14
- Kotlin 1.9.25
- Spring Boot 3.5.0
- Spring WebMVC 6.2.7 + Spring DevTools 3.5.0


### Search a specific dependency using Gradle wrapper

```zsh
./gradlew dependencyInsight --dependency mvc --configuration compileClasspath
./gradlew dependencyInsight --dependency devtools --configuration developmentOnly
```