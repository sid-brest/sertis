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
# Remove lines start unused characters with sed
    sed -i '/^$/d' $InputPath
    sed '/\d{5}$/!d' $InputPath > $OutputPath
    # sed '/(^.{15}\s.{5}\s.*\d{5}$)|(^.{3}\s.{4}\s\d{2}\.\d{2}\.\d{2})/!d' $InputPath > $OutputPath
fi


# # Write the name of the test into a variable using the commands head & sed
#     testname=$(head -n 1 $InputPath | cut -d ' ' -f 2,3)
#     success=$(tail -n 1 $InputPath | cut -d ' ' -f 1)
#     failed=$(tail -n 1 $InputPath | cut -d ' ' -f 6)
#     rating=$(tail -n 1 $InputPath | cut -d ' ' -f 11 | tr -d %, | bc)
#     duration=$(tail -n 1 $InputPath | cut -d ' ' -f 13)  
# fi
# # Prepare data to import for awk 
# sed -i -e 's/not ok  /false|/g' \
#        -e 's/ok  /true|/g' \
#        -e 's/  expecting/|expecting/g' \
#        -e 's/), /)|/g' \
#     testdata.txt
# # Create json formatted file from given data with delimitter "|"
# awk ' BEGIN {FS="|"}
# NF > 0 {
#           print  "  {"
#           print  "   \"name\": \""$3"\","
#           print  "   \"status\": "$1","
#           print  "   \"duration\": \""$4"\""
#           print  "  },"
#         } '  testdata.txt > converteddata.txt
# sed -i '1 i {\n "testname": "'"$testname"'",\n "tests":[' converteddata.txt
# # Remove comma at the EOF
# sed -i '$s/,/ /' converteddata.txt
# # Print summary at the EOF
# printf '],\n "summary": {\n  "success": '$success',\n  "failed": '$failed',\n  "rating": '$rating',\n  "duration": "'$duration'"\n  }\n}' >> converteddata.txt
# # Convert to txt to json
# cat converteddata.txt > $OutputPath
# # Remove temp files
# rm converteddata.txt testdata.txt