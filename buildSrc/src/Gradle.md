Gradle DSL (domain specific language)
Groovy:

1. no bracket // passing parameters
2. support closure // { code }
3. dynamic typed // def var

put source code in src/main/java

.gradle // local cache directory
build // build output

build script // build.gradle
task // defined in build script
./gradlew <task-name>
./gradlew tasks // display tasks

### config plugin

`which equals a predefined tasks set`

`to make gradle compile what in the src/main/java folder`

~~~groovy
plugins {
    id 'java'
}
~~~

### config packaging

`to make the packaged jar executable from command line`

`it is predefined task `

~~~groovy
jar {
    manifest {
        attributes 'Main-Class': 'path_to_class_which_contains_the_main'
    }
}
~~~

### Q & A

`to support Kotlin, what to add in build.gradle`

~~~groovy
plugins {
    id "org.jetbrains.kotlin.jvm" version "1.9.21"
}
dependencies {
    implementation(kotlin("stdlib"))
}
~~~

`to add customized task before the process resource lifecycle`
short answers: use dependOn method.

~~~groovy
task.register("myTask") {
    doLast {
        println("hello world")
    }
}
tasks.named("processResource") {
    dependOn("MyTask")
}
~~~
