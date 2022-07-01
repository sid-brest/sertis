#!/bin/bash
# Check empty argument
if [ -z "$1" ]; then
    echo "No argument provided. Type path to file data.txt, please!"
else
    path="$1"
    InputFileName="data.txt"
    OutputFileName="clear.csv"
    InputPath="$1/$InputFileName"
    OutputPath="$1/$OutputFileName"
# Remove empty lines
    sed -i '/^$/d' $InputPath
# Clear data.txt with different conditions
awk 'BEGIN {FS=" "} /^.{15}\s.{5}\s.*[0-9]{5}$/ {print}' $InputPath > $path/regnumbers.txt
sed -i 's/Регистрационный номер	//g' $path/regnumbers.txt
awk 'BEGIN {FS=" "} /^[24.]{4}.*[0-9]{2}.*$/ {print}' $InputPath > $path/days.txt
sed -i 's/2.4. Дата регистрации	//g' $path/days.txt
# Combine data into a single CSV-file
paste -d'\t' regnumbers.txt days.txt  > $OutputFileName
rm regnumbers.txt days.txt
fi