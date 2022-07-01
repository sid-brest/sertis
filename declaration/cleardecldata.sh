#!/bin/bash
# Check empty argument
if [ -z "$1" ]; then
    echo "No argument provided. Type path to file data.txt, please!"
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
sed -i -e 's/Регистрационный номер	//g' \
       -e 's/Код ОКРБ	//g' \
$OutputFileName
# Print different files with different info inside
awk 'BEGIN {FS=" "} /^[0-9]{2}/ {print $1}' $OutputPath > $path/okrb.txt
awk 'BEGIN {FS=" "} /[0-9]{5}$/ {print}' $OutputPath > $path/regnumbers.txt
rm clear.txt
fi