#!/usr/bin/env python3

import os
import re

if len(os.sys.argv) < 2:
print("No argument provided. Type path to file data.txt, please!")
os.sys.exit(1)

Use variables for file paths.
path = os.sys.argv[1]
InputFileName = "data.txt"
OutputFileName = "clear.csv"
InputPath = os.path.join(path, InputFileName)
OutputPath = os.path.join(path, OutputFileName)
OutputPathRu = os.path.join(path, "clearRu.csv")
Regnumbers = os.path.join(path, "regnumbers.txt")
Days = os.path.join(path, "days.txt")
Period = os.path.join(path, "period.txt")
Applicants = os.path.join(path, "applicants.txt")
Fullapplicants = os.path.join(path, "fullapplicants.txt")
Objects = os.path.join(path, "objects.txt")
Production = os.path.join(path, "production.txt")
Otherinfo = os.path.join(path, "otherinfo.txt")
Expert = os.path.join(path, "expert.txt")
Address = os.path.join(path, "address.txt")
Blank = os.path.join(path, "blank.txt")
Tnved = os.path.join(path, "tnved.txt")
Okp = os.path.join(path, "okp.txt")
Status = os.path.join(path, "status.txt")

Read data from input file and write to output files.
with open(InputPath, "r") as input_file,
open(Regnumbers, "w") as regnumbers_file,
open(Days, "w") as days_file,
open(Period, "w") as period_file,
open(Objects, "w") as objects_file,
open(Applicants, "w") as applicants_file,
open(Fullapplicants, "w") as fullapplicants_file,
open(Production, "w") as production_file,
open(Otherinfo, "w") as otherinfo_file,
open(Expert, "w") as expert_file,
open(Address, "w") as address_file,
open(Blank, "w") as blank_file,
open(Tnved, "w") as tnved_file,
open(Okp, "w") as okp_file,
open(Status, "w") as status_file:

awk
Copy
for line in input_file:
    # Extract data and write to output files.
    match = re.search(r'^\s*Регистрационный номер:\s*(\S+)\s*$', line)
    if match:
        regnumbers_file.write(match.group(1) + '\n')
        continue
    match = re.search(r'^\s*2\.4\. Дата регистрации\s*(.*)$', line)
    if match:
        days_file.write(re.sub(r'\D', '', match.group(1)) + '\n')
        continue
    match = re.search(r'^\s*2\.5\. Срок действия\s*(.*)$', line)
    if match:
        period_file.write(re.sub(r'\D', '', match.group(1)) + '\n')
        continue
    match = re.search(r'^\s*Информация об использовании продукции.*\n.*\n.*\n.*\n\s*(.*)\s*$', line)
    if match:
        objects_file.write(match.group(1) + '\n')
        continue
    match = re.search(r'^\s*Краткое наименование хозяйствующего субъекта\s*(.*)$', line)
    if match:
        applicants_file.write(re.sub(r'\s+', ' ', match.group(1)).strip() + '\n')
        continue
    match = re.search(r'^\s*Наименование хозяйствующего субъекта\s*(.*)$', line)
    if match:
        fullapplicants_file.write(re.sub(r'\s+', ' ', match.group(1)).strip() + '\n')
        continue
    match = re.search(r'^\s*2\.7\. Типографский номер бланка сертификата\s*(.*)$', line)
    if match:
        blank_file.write(re.sub(r'\D', '', match.group(1)) + '\n')
        continue
    match = re.search(r'^\s*Объект оценки соответствия №1\s*(.*)$', line)
    if match:
        production_line = re.sub(r'\s+', ' ', match.group(1)).strip()
        line = next(input_file)
        while not re.search(r'^\s*