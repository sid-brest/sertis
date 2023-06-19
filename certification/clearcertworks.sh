#!/bin/bash

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
OutputPathRu="$path/clearRu.csv"
Regnumbers="$path/regnumbers.txt"
Days="$path/days.txt"
Period="$path/period.txt"
Applicants="$path/applicants.txt"
Fullapplicants="$path/fullapplicants.txt"
Objects="$path/objects.txt"
Production="$path/production.txt"
Otherinfo="$path/otherinfo.txt"
Expert="$path/expert.txt"
Address="$path/address.txt"
Blank="$path/blank.txt"
Tnved="$path/tnved.txt"
Okp="$path/okp.txt"

sed -nE '/Регистрационный номер:[ \t]/s/Регистрационный номер:[ \t]//p' "$InputPath" | sed 's/[[:space:]]\+$//' > "$Regnumbers"
sed -nE '/2\.4\. Дата регистрации/s/2\.4\. Дата регистрации//p' "$InputPath" | sed -E 's/[^0-9\.]+//g' > "$Days"
sed -nE '/2\.5\. Срок действия/s/2\.5\. Срок действия//p' "$InputPath" | sed -E 's/[^0-9\.]+//g' > "$Period"
sed -n 's/.*объект выполнения работ - \(.*\), .*/\1/p' "$InputPath" | sed 's/, .*//g' > "$Objects"
sed -nE '/Краткое наименование хозяйствующего субъекта[ \t]/s/Краткое наименование хозяйствующего субъекта[ \t]//p' "$InputPath" | sed -E 's/ +([a-zA-Z])/\1/g' | sed '/^\s*$/d' > "$Applicants"
sed -nE '/Наименование хозяйствующего субъекта[ \t]/s/Наименование хозяйствующего субъекта[ \t]//p' "$InputPath" | sed -E 's/ +([a-zA-Z])/\1/g' | sed '/^\s*$/d' > "$Fullapplicants"
sed -nE '/2\.7\. Типографский номер бланка сертификата[ \t]/s/2\.7\. Типографский номер бланка сертификата[ \t]//p' "$InputPath" | sed 's/[^0-9]+//g' > "$Blank"
sed -nE '/(Объект|Наименование) объекта оценки соответствия[ \t]/s/(Объект|Наименование) объекта оценки соответствия[ \t]//p' "$InputPath" | sed -E 's/ +([a-zA-Z])/\1/g' | sed '/^\s*$/d' > "$Production"
sed -nE '/Иные сведения об объекте оценки соответствия, обеспечивающие его идентификацию/s/Иные сведения об объекте оценки соответствия, обеспечивающие его идентификацию//p; /./!d; N; s/\n/ /' "$InputPath" | sed 's/^[ \t]*//' > "$Otherinfo"

# Combine data into a single CSV-file.
 paste -d'\t' "$Regnumbers" "$Blank" "$Days" "$Period" "$Applicants" "$Fullapplicants" "$Objects" <(paste -d' ' "$Production" "$Otherinfo") > "$OutputPath" 
 paste -d'\t' "$Regnumbers" "$Blank" "$Days" "$Period" "$Applicants" "$Fullapplicants" "$Objects" <(paste -d' ' "$Production" "$Otherinfo") | iconv -f UTF-8 -t windows-1251 > "$OutputPathRu"

# Remove temporary files.
find $1 -name "*.txt" -not -name "*data*.txt" -type f -delete