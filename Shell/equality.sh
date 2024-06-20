#!/usr/bin/env bash

var1="value1"
var2="value2"
var3="value1"

if [ "$var1" == "$var2" ]; then
  echo "The var 1 and var2  are equal."
elif [ "$var1" != "$var2" ]; then
  echo "The var1 and var2 are not equal."
fi

if [ "$var1" == "$var3" ]; then
  echo "The var1 and var3 are equal."
fi