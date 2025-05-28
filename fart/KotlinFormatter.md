# Official recommended Kotlin formatter

```.kotlin
ktlint {
    version.set("0.50.0")
    reporters {
        reporter(org.jlleitschuh.gradle.ktlint.reporter.ReporterType.PLAIN)
    }
}
```

## It can
- Format `.kt`,`.kts` and `.kotlin` files
- Scan its parent directory for `.editorconfig` files, it fails if any of the files is not valid
- Format Kotlin code
- Remove unused imports
- Execute by `./gradlew ktlintFormat`