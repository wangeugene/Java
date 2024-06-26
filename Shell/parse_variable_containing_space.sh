#!/usr/bin/env bash
# Using bash will need to use double quotes around the variable name
# But using zsh will not need to use double quotes around the variable name

# The relative path to the file
secret_file="./folder with spaces/readme.txt"
# Be aware of the double quotes around the variable name, single quotes around the variable value will not work

echo $(cat "$secret_file")
