#!/bin/bash

set -e  # Exit immediately if a command fails

# Step 1: Go to cs236-xv6-mac
cd cs236-xv6-mac

# Step 2: Remove old tar.gz if it exists
if [ -f assignment3_easy_2024JCS2043_2024JCS2042.tar.gz ]; then
    echo "Removing old tar.gz in cs236-xv6-mac..."
    rm assignment3_easy_2024JCS2043_2024JCS2042.tar.gz
fi

# Step 3: make clean
echo "Running make clean..."
make clean

# Step 4: Create new tar.gz (excluding itself properly)
echo "Creating new tar.gz..."
tar --exclude='assignment3_easy_2024JCS2043_2024JCS2042.tar.gz' -czvf assignment3_easy_2024JCS2043_2024JCS2042.tar.gz *

# Step 5: Go to check_script
cd ../check_script

# Step 6: Remove old tar.gz if exists
if [ -f assignment3_easy_2024JCS2043_2024JCS2042.tar.gz ]; then
    echo "Removing old tar.gz in check_script..."
    rm assignment3_easy_2024JCS2043_2024JCS2042.tar.gz
fi

# Step 7: Remove old test_dir if exists
if [ -d test_dir ]; then
    echo "Removing old test_dir..."
    rm -rf test_dir
fi

# Step 8: Copy new tar.gz from cs236-xv6-mac
echo "Copying new tar.gz to check_script..."
cp ../cs236-xv6-mac/assignment3_easy_2024JCS2043_2024JCS2042.tar.gz .

# Step 9: Run the checker
echo "Running run.sh to test submission..."
./run.sh assignment3_easy_2024JCS2043_2024JCS2042.tar.gz

echo "✅ Done!"

