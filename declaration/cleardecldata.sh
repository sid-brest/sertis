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
    Otherinfo="$1/otherinfo.txt"
    Expert="$1/expert.txt"
# Remove empty lines and 10 lines after match 
    sed -i -e '/^$/d' \
           -e '/Единица объекта оценки соответствия №/,+10d' \
$InputPath
# Replace text with new line symbols 
perl -p -e 's/^[215.]{5}.*\n/2.15. ФИО эксперта (эксперта-аудитора) /g' $InputPath > newdata.txt
# Clear data.txt with different conditions
awk 'BEGIN {FS=" "} /^.{15}\s.{5}\s.*[0-9]{5}$/ {print}' $InputPath > $Regnumbers
sed -i 's/Регистрационный номер	//g' $Regnumbers
awk 'BEGIN {FS=" "} /^[24.]{4}.*[0-9]{2}.*$/ {print}' $InputPath > $Days
sed -i 's/2.4. Дата регистрации	//g' $Days
awk 'BEGIN {FS=" "} /^.{12}\s.{14}\s.{8}\s.*$/ {print}' $InputPath > $Applicants
sed -i 's/Наименование хозяйствующего субъекта	//g' $Applicants
sed -i '/^$/d' $Applicants
awk 'BEGIN {FS=" "} /^.{12}\s.{7}\s.{6}\s.{12}\s.*$/ {print}' $InputPath > $Objects
sed -i 's/Наименование объекта оценки соответствия	//g' $Objects
sed -i '/^$/d' $Objects
awk 'BEGIN {FS=" "} /^.{4}\s.{8}\s.{2}\s.{7}\s.{6}\s.{12}.*$/ {print}' $InputPath > $Otherinfo
sed -i 's/Иные сведения об объекте оценки соответствия, обеспечивающие его идентификацию	//g' $Otherinfo
awk 'BEGIN {FS=" "} /^[2]{1}\.[1]{1}[5]{1}\.\s.*$/ {print}' newdata.txt > $Expert
sed -i 's/2.15. ФИО эксперта (эксперта-аудитора) //g' $Expert
# Change full initials to abbreviated initials
awk 'BEGIN {FS=" "} {print substr($2,1,1)"."substr($3,1,1)"."$1}' $Expert > experttemp.txt
# Combine data into a single CSV-file
paste -d' ' $Objects $Otherinfo > ObjectsOtherinfo.txt
paste -d'\t' $Regnumbers $Days $Applicants ObjectsOtherinfo.txt experttemp.txt > $OutputFileName
rm $Regnumbers $Days $Applicants $Objects $Otherinfo ObjectsOtherinfo.txt newdata.txt experttemp.txt $Expert
fi