#!/bin/bash

# Output CSV file
output_file="result_b.csv"

# Write the CSV header
echo -n "submission" > "$output_file"
# for i in {1..4}; do
#     echo -n ",test_b, test_c,test_f,test_g" >> "$output_file"
# done
echo -n ",test_b,Error" >> "$output_file"
echo "" >> "$output_file"

# Loop through all matching files
for submission in assignment2_easy_*.tar.gz; do
    echo "Processing $submission"
    ./check.sh "$submission" "$output_file"
done
