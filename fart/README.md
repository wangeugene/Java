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

### Run the application using the IDEA
Since Gradle and IDEA use different build systems, it is important to ensure that the IDEA is configured correctly to run the application.
Unfortunately, the IDEA does not always pick up the correct JDK version set in the configuration files.
A few things to check in order to run the application in the IDEA:
1. Make sure the JDK version is set to 21 in the IDEA settings.
2. In Settings > Build, Execution, Deployment > Build Tools > Gradle, set the Gradle JVM to 21.
3. Waiting for build tab to finish, then run the application using the green play button in the top right corner of the IDEA.
4. Change modules, the correct source set is set.
