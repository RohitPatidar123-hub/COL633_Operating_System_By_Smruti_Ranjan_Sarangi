#!/bin/bash

# Output CSV file
output_file="result_test_sched2.csv"

# Write the CSV header
echo -n "submission" > "$output_file"
for i in {1..4}; do
    echo -n ",pid,TAT,WT,RT,#CS" >> "$output_file"
done
echo "" >> "$output_file"

# Loop through all matching files
for submission in assignment2_easy_*.tar.gz; do
    echo "Processing $submission"
    ./check.sh "$submission" "$output_file"
done
