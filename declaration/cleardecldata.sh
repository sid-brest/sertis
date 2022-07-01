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
    Regnumbers="$1/regnumbers.txt"
    Days="$1/days.txt"
    Applicants="$1/applicants.txt"
    Objects="$1/objects.txt"
# Remove empty lines
    sed -i '/^$/d' $InputPath
# Replace text with new line symbols 
    perl -i -p -e 's/(Объект оценки соответствия №[1]\n)|(Объект оценки соответствия №[1]\s\n)/Объект оценки соответствия /g' $InputPath
# Clear data.txt with different conditions
awk 'BEGIN {FS=" "} /^.{15}\s.{5}\s.*[0-9]{5}$/ {print}' $InputPath > $Regnumbers
sed -i 's/Регистрационный номер	//g' $Regnumbers
awk 'BEGIN {FS=" "} /^[24.]{4}.*[0-9]{2}.*$/ {print}' $InputPath > $Days
sed -i 's/2.4. Дата регистрации	//g' $Days
awk 'BEGIN {FS=" "} /^.{12}\s.{14}\s.{8}\s.*$/ {print}' $InputPath > $Applicants
sed -i 's/Наименование хозяйствующего субъекта	//g' $Applicants
sed -i '/^$/d' $Applicants
awk 'BEGIN {FS=" "} /^.{6}\s.{6}\s.{12}\s.{12}\s.{7}\s.{6}\s.{12}\s.*$/ {print}' $InputPath > $Objects
sed -i 's/Объект оценки соответствия Наименование объекта оценки соответствия	//g' $Objects
sed -i '/^$/d' $Objects
# Combine data into a single CSV-file
paste -d'\t' $Regnumbers $Days $Applicants $Objects > $OutputFileName
rm $Regnumbers $Days $Applicants $Objects
fi