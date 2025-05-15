#!/bin/bash


submission=$1
csv_file=$2
rm -rf ./test_dir
rm -rf test_dir
mkdir ./test_dir
rm -rf ./test_dir/*

echo $submission

fileNameRegex_double="assignment2_easy_[0-9]{4}[A-Za-z]{2,3}[0-9]{4,5}.tar.gz"
fileNameRegex_single="assignment2_easy_[0-9]{4}[A-Za-z]{2,3}[0-9]{4,5}_[0-9]{4}[A-Za-z]{2,3}[0-9]{4,5}.tar.gz"

if ! [[ $submission =~ $fileNameRegex_double || $submission =~ $fileNameRegex_single ]]; then
    echo "File doesn't match the naming convention"
    exit
fi

echo "Setting the test directory"
tar -xzf "$submission" -C ./test_dir
cp tom.c test_sched.c test_f.sh Makefile sh.c ./test_dir
cd ./test_dir || exit

# expect -f test_b.sh "$submission" "$csv_file"
# expect -f test_c.sh "$submission" "$csv_file"
expect -f test_f.sh "$submission" "$csv_file"
# expect -f test_g.sh "$submission" "$csv_file"


