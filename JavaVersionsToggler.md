# install this tool to switch between java versions on Mac

```zsh
brew install jenv
```

# add existing java versions to jenv for management

```zsh
jenv add /opt/homebrew/opt/openjdk@17
jenv add /opt/homebrew/Cellar/openjdk@11/11.0.22
jenv versions
jenv global 17
jenv global 11
```

## sometimes you must open a new terminal and run the following command to verify the java version

```zsh
java -version
echo $JAVA_HOME
```

your environment variable JAVA_HOME should become empty after running the above command