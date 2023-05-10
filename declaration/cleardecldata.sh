#!/bin/bash

# Check if argument is provided
if [ -z "$1" ]; then
  echo "No argument provided. Please type the path to file data.txt!"
  exit 1 # Exit with non-zero status to indicate error
fi

# Set variables for file paths
path="$1"
InputFileName="data.txt"
OutputFileName="clear.csv"
InputPath="$path/$InputFileName"
OutputPath="$path/$OutputFileName"
Regnumbers="$path/regnumbers.txt"
Days="$path/days.txt"
Applicants="$path/applicants.txt"
Objects="$path/objects.txt"
Otherinfo="$path/otherinfo.txt"
Expert="$path/expert.txt"
Address="$path/address.txt"

# Remove empty lines and 10 lines after match 
sed -i -e '/^$/d' \
  -e '/^Единица объекта оценки соответствия №/,+10d' \
  "$InputPath"

# Replace text with new line symbols
perl -p -e 's/^[215.]{5}.*\n/2.15. ФИО эксперта (эксперта-аудитора) /g' "$InputPath" > newdata.txt

# Focus on Regnumbers
awk 'BEGIN {FS=" "} /^.{15}\s.{5}\s.*[0-9]{5}$/ {print}' "$InputPath" > "$Regnumbers"
sed -i 's/Регистрационный номер	//g' "$Regnumbers"

# Focus on Days
awk 'BEGIN {FS=" "} /^[24.]{4}.*[0-9]{2}.*$/ {print}' "$InputPath" > "$Days"
sed -i 's/2.4. Дата регистрации	//g' "$Days"

# Focus on Applicants
awk 'BEGIN {FS=" "} /^.{12}\s.{14}\s.{8}\s.*$/ {print}' "$InputPath" > "$Applicants"
sed -i 's/Наименование хозяйствующего субъекта	//g' "$Applicants"
sed -i '/^$/d' "$Applicants"

# Focus on Objects
awk 'BEGIN {FS=" "} /^.{12}\s.{7}\s.{6}\s.{12}\s.*$/ {print}' "$InputPath" > "$Objects"
sed -i 's/Наименование объекта оценки соответствия	//g' "$Objects"
sed -i '/^$/d' "$Objects"

# Focus on Otherinfo
awk 'BEGIN {FS=" "} /^.{4}\s.{8}\s.{2}\s.{7}\s.{6}\s.{12}.*$/ {print}' "$InputPath" > "$Otherinfo"
sed -i 's/Иные сведения об объекте оценки соответствия, обеспечивающие его идентификацию	//g' "$Otherinfo"

# Focus on Experts
awk 'BEGIN {FS=" "} /^[2]{1}\.[1]{1}[5]{1}\.\s.*$/ {print}' newdata.txt > "$Expert"
sed -i 's/2.15. ФИО эксперта (эксперта-аудитора) //g' "$Expert"

# Change full initials to abbreviated initials
awk 'BEGIN {FS=" "} {print substr($2,1,1)"."substr($3,1,1)"."$1}' "$Expert" > experttemp
mv experttemp "$Expert"

# Focus on Address
awk 'BEGIN {FS=" "} /^Адрес заявителя.*$/ {print}' "$InputPath" > "$Address"
sed -i 's/^.*Адрес заявителя	(BY) Беларусь, (1) Место нахождения (адрес юр. лица), //g' "$Address"
sed -i 's/^.*Адрес в текстовой форме//g' "$Address"
sed -i 's/ Республика Беларусь//g' "$Address"
sed -i 's/^\://g' "$Address"
sed -i 's/^\,//g' "$Address"
sed -i 's/^\ //g' "$Address"
sed -i 's/: / /g' "$Address"
sed -i 's/Номер дома //g' "$Address"
sed -i 's/Город /г. /g' "$Address"
sed -i 's/Улица /ул. /g' "$Address"
sed -i 's/Номер помещения / /g' "$Address"
sed -i 's/ Населенный пункт / /g' "$Address"
sed -i 's/Область Минск, //g' "$Address"
sed -i 's/сельский совет/c\/c/g' "$Address"
sed -i 's/агрогородок/аг\./g' "$Address"
sed -i 's/агрогородка/аг\./g' "$Address"
sed -i 's/область/обл\./g' "$Address"
sed -i 's/район/р\-н/g' "$Address"
sed -i 's/ Номер абонентского ящика.*//g' "$Address"
sed -i 's/ Почтовый//g' "$Address"
sed -i 's/\s*$//g' "$Address"
sed -i 's/\,*$//g' "$Address"
sed -i 's/ *| */|/g' "$Address"
sed -i 's/^\(Область\) \([^ ,]*\)/\2 \1/' "$Address"
sed -i 's/Область/обл\./g' "$Address"

# Combine data into a single CSV-file
paste -d'\t' "$Regnumbers" "$Days" "$Applicants" <(paste -d' ' "$Objects" "$Otherinfo") "$Address" "$Expert" > "$OutputPath"

# Remove temporary files
rm "$Regnumbers" "$Days" "$Applicants" "$Objects" "$Otherinfo" newdata.txt "$Expert" "$Address"

# Exit successfully
exit 0