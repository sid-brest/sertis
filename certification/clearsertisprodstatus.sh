#!/bin/bash

# if [ -z "$1" ]; then
#   echo "No argument provided. Type path to file data.txt, please!"
#   exit 1
# fi

# Use variables for file paths.
path="$PWD"
InputFileName="copy.txt"
OutputFileName="clear.csv"
InputPath="$path/$InputFileName"
OutputPath="$path/$OutputFileName"
OutputPathRu="$path/clearRu.csv"
Nameobject="$path/nameobject.txt"

Regnumbers="$path/regnumbers.txt"
Days="$path/days.txt"
Period="$path/period.txt"
# ID="$path/ID.txt"
# NameHead="$path/nameHead.txt"
# DocumentDate="$path/documentDate.txt"
# Telefax="$path/telefax.txt"
Applicants="$path/applicants.txt"
Fullapplicants="$path/fullapplicants.txt"
Objects="$path/objects.txt"

Production="$path/production.txt"
Otherinfo="$path/otherinfo.txt"
Expert="$path/expert.txt"
Address="$path/address.txt"
Blank="$path/blank.txt"
Okp="$path/okp.txt"
Thved="$path/Thved.txt"
Status="$path/status.txt"
StatusInfo="$path/statusinfo.txt"

cp $path/data.txt copy.txt
sed -i -e '/Единица объекта оценки соответствия/,/Дата документа/d' copy.txt
sed -i -e '/Объект оценки соответствия №2/,/Код товара по ТН ВЭД ЕАЭС/d' copy.txt

# Collecting information about document
sed -nE '/Регистрационный номер:[ \t]/s/Регистрационный номер:[ \t]//p' "$InputPath" | sed 's/[[:space:]]\+$//' > "$Regnumbers"
sed -nE '/2\.4\. Дата регистрации/s/2\.4\. Дата регистрации//p' "$InputPath" | sed -E 's/[^0-9\.]+//g' > "$Days"
sed -nE '/2\.5\. Срок действия/s/2\.5\. Срок действия//p' "$InputPath" | sed -E 's/[^0-9\.]+//g' > "$Period"
sed -nE '/2\.7\. Типографский номер бланка сертификата[ \t]/s/2\.7\. Типографский номер бланка сертификата[ \t]//p' "$InputPath" | sed 's/[^0-9]+//g' > "$Blank"
sed -nE '/Информация об использовании продукции*./,/, расположен по адресу /{//!p}' "$InputPath" > "$Objects"
sed -nE '/Краткое наименование хозяйствующего субъекта[ \t]/s/Краткое наименование хозяйствующего субъекта[ \t]//p' "$InputPath" | sed -E 's/ +([a-zA-Z])/\1/g' | sed '/^\s*$/d' > "$Applicants"
sed -nE '/Наименование хозяйствующего субъекта[ \t]/s/Наименование хозяйствующего субъекта[ \t]//p' "$InputPath" | sed -E 's/ +([a-zA-Z])/\1/g' | sed '/^\s*$/d' > "$Fullapplicants"


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
# sed -nE '/Адрес заявителя /s/Адрес заявителя //p' "$InputPath" | sed -E 's/(Адрес заявителя|Место нахождения|адрес|юр. лица|Область|Город|Улица|Номер дома|Почтовый индекс)//g; s/[:,()]//g; s/\s+/ /g; s/^ //' > "$Address"
# sed -nE '/ФИО[ \t]/s/ФИО[ \t]//p' "$InputPath" | awk '{print $1, substr($2,1,1) "." substr($3,1,1) "."}' | awk '{split($0,a," "); printf "%s%s\n", a[2], a[1]}' > "$NameHead"
# sed -nE 'Дата документа/s/Дата документа//p' "$InputPath" | sed -E 's/[^0-9\.]+//g' > "$DocumentDate"
# sed -nE '/Идентификатор хозяйствующего субъекта/s/Идентификатор хозяйствующего субъекта//p' "$InputPath" | sed -E 's/[^0-9]+//g' > "$ID"
# sed -nE '/\(FX\) телефакс/s/\(FX\) телефакс//p' "$InputPath" | sed -E 's/[^0-9\+]+//g' > "$Telefax"

# Collecting information about object
awk '/Наименование объекта оценки соответствия/ { sub("Наименование объекта оценки соответствия", ""); print }' "$InputPath" | awk '{ gsub(/[a-zA-Z]+/, ""); print }' > "$Production"
sed -nE '/Иные сведения об объекте оценки соответствия, обеспечивающие его идентификацию/s/Иные сведения об объекте оценки соответствия, обеспечивающие его идентификацию//p; /./!d; N; s/\n/ /' "$InputPath" | sed 's/^[ \t]*//' > "$Otherinfo"
sed -nE '/^2\.15\./{n;p}' "$InputPath" | awk '{print $1, substr($2,1,1) "." substr($3,1,1) "."}' | awk '{split($0,a," "); printf "%s%s\n", a[2], a[1]}' > "$Expert"
sed -nE '/2\.4\. Дата регистрации/s/2\.4\. Дата регистрации//p' "$InputPath" | sed -E 's/[^0-9\.]+//g' > "$Days"
sed -nE '/Код ОКРБ[ \t]/s/Код ОКРБ[ \t]//p' "$InputPath" | sed -E 's/[^0-9\.]+//g' > "$Okp"
sed -nE '/^Статус действия сертификата.*, с/s/^Статус действия сертификата.*, с//p' "$InputPath" | awk '{gsub(/ по /, ""); print}' | sed -E 's/[^0-9\.]+//g' > "$Status"
sed -nE '/^Основание для изменения статуса сертификата.*/{n;p}' "$InputPath" | awk '{gsub("Описание причины изменения статуса действия сертификата \\(декларации\\)", ""); print}' | awk '{gsub("\t", ""); print}' > "$StatusInfo"
sed -nE '/Код товара по ТН ВЭД ЕАЭС/s/Код товара по ТН ВЭД ЕАЭС//p' "$InputPath" | sed -E 's/[^0-9]+//g' > "$Thved"

paste -d' ' "$Production" "$Otherinfo" > "$Nameobject"

# Combine data into a single CSV-file.
paste -d'\t' "$Regnumbers" "$Days" "$Period" "$Status" "$Blank" "$Thved" "$Fullapplicants" "$Applicants" "$Nameobject" "$Address" "$Okp" "$Expert" "$StatusInfo" > "$OutputPath" 

# Remove temporary files.
find $1 -name "*.txt" -not -name "*data*.txt" -type f -delete