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
