# Gradle Tips

## Best Practices

- Use `gradle init` to create a new Gradle project, which sets up the basic structure and files.
- Use `./gradlew` instead of `gradle` to ensure the correct Gradle version is used.
- Prefer `build.gradle.kts` for Kotlin DSL over `build.gradle` for Groovy DSL. because it provides better type safety and IDE support.
- To convert a Maven project to Gradle, use `gradle init --type pom` to generate a Gradle build file from an existing Maven `pom.xml`.

### Terminologies

Build script: contains automation instructions for a project
Task: defines executable automation instructions

#### Setting the Main Class

#### Gradle Wrapper

gradle wrapper command created this folder: /gradle/wrapper
gradle-wrapper.properties will determine the Gradle version

#### build.gradle

Resides in a root directory of project hierarchy
Contains all build logic
Can become hard to maintain
Can split into multiple build.gradle for maintainability

#### settings.build

Resides in a root directory of project hierarchy
Declares participating projects
Can change defaults(e.g. project name)
Following command to print out the settings.build

#### gradle.properties

Resides in a root directory of project hierarchy or Gradle user home directory
Preconfigures runtime behavior
can
set the project version
set the project log level

#### typed task

these are pre-defined tasks build that can be extended,
e.g., the tasks that take type: arguments from a pre-defined type

#### task execution order

Task A depends on Task B;C
Ensures that B and C are executed before A
Does not explicit ly define if B or C executed first

#### Directed Acyclic Graph (DAG)

Task is represented as node
Task dependency is represented as graph-edge
Gradle forbids circular dependencies

#### List of tasks & Run a single task

~~~shell
./gradlew tasks --all
./gradlew hello --dry-run
~~~

#### build execution under the hood

Evaluates instructions in build scripts,
Creates and configures tasks
Execute tasks in the correct order

#### life cycle phase of every build

Initialization phase -> Configuration phase -> Execution phase
(Evaluates settings file and sets up the build) -> (Evaluates build scripts and runs configuration logic)
-> (Executes in the correct order)

#### Goal of plugins

Avoid repetitive code
Make build logic more maintainable
Provide reusable functionality across projects
Two types of plugins: script plugin (e.g., archiving.gradle)
or binary plugin ('base' in root build.gradle file)(more complex)

### View dependencies

```zsh
./gradlew -q dependencies --configuration testRuntimeClasspath
./gradlew -q dependencies --configuration tRC
./gradlew -q dependencyInsight --dependency snakeyaml
```

#### View a single dependency from a war file or a jar file in a Gradle project

execute the following command in unix shell from project root directory

```zsh
jar -tf build/libs/example.war | grep contrib
```