#!/bin/bash
# Check empty argument
if [ -z "$1" ]; then
    echo "No argument provided. Type path, please!"
else
    path="$1"
    InputFileName="data.txt"
    OutputFileName="clear.txt"
    InputPath="$1/$InputFileName"
    OutputPath="$1/$OutputFileName"
# Remove empty lines
    sed -i '/^$/d' $InputPath
# Leave lines start with registration number and okrb
    awk '/(^.{15}\s.{5}\s.*[0-9]{5}$)|(^.{3}\s.{4}\s[0-9]{2})/' $InputPath > $OutputPath
fi