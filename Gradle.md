Gradle DSL (domain-specific language)

### Terminologies

Build script: contains automation instructions for a project
Task: defines executable automation instructions

#### Setting the Main Class

~~~groovy
jar {
    manifest {
        attributes 'Main-Class': 'path_to_class_which_contains_the_main'
    }
}
~~~

#### Kotlin Support

~~~groovy
plugins {
    id "org.jetbrains.kotlin.jvm" version "1.9.21"
}
dependencies {
    implementation(kotlin("stdlib"))
}
~~~

#### Define A Task

defined in the root directory: project root/build.gradle

~~~groovy  
task "helloWorld" {
    doLast {
        println("hello world")
    }
}
~~~

~~~shell
gradle helloWorld
gradle wrapper 
gradlew helloWorld
~~~

#### Gradle Wrapper

gradle wrapper command created this folder: /gradle/wrapper
gradle-wrapper.properties will determine the gradle version



