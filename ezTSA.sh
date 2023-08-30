#!/bin/bash

# This Bash script allows you to easily use the Time Stamping Authority (TSA) service provided by FreeTSA.org.
# The script takes the file path as an argument, creates a folder named after the file ending with "_TSA" in the same directory as the original file, and moves the file into that folder.
# The script then generates a timestamp query (tsq) file for the specified file, sends a timestamp request to FreeTSA.org, and verifies the timestamp response (tsr) file.
# The only file that ever leaves your machine is the tsq file which contains the SHA 512 hash of the file you are timestamping.

FILEPATH=$1
FILE=$(basename $FILEPATH)
FILE_DIR=$(dirname $FILEPATH)
NEW_FOLDER=$FILE_DIR/$FILE\_TSA

# Create a folder named after the file ending with "_TSA" in the same directory as the original file
mkdir -p $NEW_FOLDER

# Move the file into the folder
cp $FILEPATH $NEW_FOLDER/$FILE

# 1. create a tsq file (SHA 512)
openssl ts -query -data $NEW_FOLDER/$FILE -no_nonce -sha512 -out $NEW_FOLDER/$FILE.tsq > /dev/null 2>&1; wait

# 2. cURL Time Stamp Request Input (HTTP / HTTPS)
curl -s -H "Content-Type: application/timestamp-query" --data-binary "@$NEW_FOLDER/$FILE.tsq" https://freetsa.org/tsr > $NEW_FOLDER/$FILE.tsr; wait

# 3. Verify tsr file
wget https://freetsa.org/files/tsa.crt -O $NEW_FOLDER/tsa.crt > /dev/null 2>&1; wait
wget https://freetsa.org/files/cacert.pem -O $NEW_FOLDER/cacert.pem > /dev/null 2>&1; wait

# Timestamp Information.
openssl ts -reply -in $NEW_FOLDER/$FILE.tsr -text 2> /dev/null | grep "^Time stamp:"; wait

# Verify timestamp
openssl ts -verify -in $NEW_FOLDER/$FILE.tsr -queryfile $NEW_FOLDER/$FILE.tsq -CAfile $NEW_FOLDER/cacert.pem -untrusted $NEW_FOLDER/tsa.crt 2> /dev/null | tail -n 1
