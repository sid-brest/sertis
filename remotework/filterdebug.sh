#!/bin/bash
read -p "Enter input file name: " input_file
read -p "Enter output file name: " output_file
cat $input_file | grep "./Dec/2022.*SID" > $output_file