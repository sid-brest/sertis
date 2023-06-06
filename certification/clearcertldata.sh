#!/bin/bash

# Exit immediately if any command exits with a non-zero status.
set -e

if [ -z "$1" ]; then
  echo "No argument provided. Type path to file data.txt, please!"
  exit 1
fi

# Use variables for file paths.
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
Blank="$path/blank.txt"
Tnved="$path/tnved.txt"
Okp="$path/okp.txt"

# Remove empty lines and 10 lines after match.
sed -i -e '/^$/d' \
       -e '/Единица объекта оценки соответствия №/,+10d' \
  "$InputPath"

# Replace text with new line symbols.
perl -p -e 's/^[215.]{5}.*\n/2.15. ФИО эксперта (эксперта-аудитора) /g' "$InputPath" > newdata.txt

# Focus on Regnumbers.
awk 'BEGIN {FS=" "} /^.{15}\s.{5}\s.*[0-9]{5}$/ {print}' "$InputPath" > "$Regnumbers"
sed -i 's/Регистрационный номер	//g' "$Regnumbers"

# Focus on Days.
awk 'BEGIN {FS=" "} /^[24.]{4}.*[0-9]{2}.*$/ {print}' "$InputPath" > "$Days"
sed -i 's/2.4. Дата регистрации	//g' "$Days"

# Focus on Applicants.
awk 'BEGIN {FS=" "} /^.{12}\s.{14}\s.{8}\s.*$/ {print}' "$InputPath" > "$Applicants"
sed -i 's/Наименование хозяйствующего субъекта	//g' "$Applicants"
sed -i '/^$/d' "$Applicants"

# Focus on Objects.
awk 'BEGIN {FS=" "} /^.{12}\s.{7}\s.{6}\s.{12}\s.*$/ {print}' "$InputPath" > "$Objects"
sed -i 's/Наименование объекта оценки соответствия	//g' "$Objects"
sed -i '/^$/d' "$Objects"

# Focus on Otherinfo.
awk 'BEGIN {FS=" "} /^.{4}\s.{8}\s.{2}\s.{7}\s.{6}\s.{12}.*$/ {print}' "$InputPath" > "$Otherinfo"
sed -i 's/Иные сведения об объекте оценки соответствия, обеспечивающие его идентификацию	//g' "$Otherinfo"

# Focus on Experts.
awk 'BEGIN {FS=" "} /^[2]{1}\.[1]{1}[5]{1}\.\s.*$/ {print}' newdata.txt > "$Expert"
sed -i 's/2.15. ФИО эксперта (эксперта-аудитора) //g' "$Expert"

# Change full initials to abbreviated initials.
awk 'BEGIN {FS=" "} {print substr($2,1,1)"."substr($3,1,1)"."$1}' "$Expert" > experttemp.txt

# Focus on Forms.
awk 'BEGIN {FS=" "} /^[2]{1}\.[7]{1}\.\s.*$/ {print}' "$InputPath" > "$Blank"
sed -i 's/2.7. Типографский номер бланка сертификата	//g' "$Blank"

# Focus on TN VED.
awk 'BEGIN {FS=" "} /Код товара по ТН ВЭД ЕАЭС/ {found=0; for(i=1; i<=NF; i++) {if($i ~ /^[0-9]{4,10}$/) {print $i; found=1}} if(found==0) print " "}' "$InputPath" > "$Tnved"
sed -i 's/Код товара по ТН ВЭД ЕАЭС	//g' "$Tnved"

# Focus on OKP.
awk 'BEGIN {FS=" "} /Код ОКРБ/ {found=0; for(i=1; i<=NF; i++) {if($i ~ /^[0-9]{2}\.[0-9]{2}\.[0-9]{1,2}$/){print $i; found=1}} if(found==0) print ""}' "$InputPath" > "$Okp"
sed -i 's/Код ОКРБ	//g' "$Okp"

# Focus on Address.
awk 'BEGIN {FS=" "} /^Адрес заявителя.*$/ {print}' "$InputPath" > "$Address"
sed -i 's/Адрес заявителя	(BY) Беларусь, (1) Место нахождения (адрес юр. лица), //g' "$Address"
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

# Combine data into a single CSV-file.
paste -d'\t' "$Regnumbers" "$Blank" "$Days" "$Applicants" "$Tnved" "$Okp" "$Address" <(paste -d' ' "$Objects" "$Otherinfo") experttemp.txt > "$OutputPath"

# Remove temporary files.
rm newdata.txt experttemp.txt "$Regnumbers" "$Blank" "$Days" "$Applicants" "$Objects" "$Otherinfo" "$Expert" "$Address" "$Tnved" "$Okp"