#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <url> <output_file_path>"
    exit 1
fi

# Assign the arguments to variables
URL=$1
OUTPUT_FILE_PATH=$2

# Check if the output file path ends with a file name
if [ -d "$OUTPUT_FILE_PATH" ]; then
    echo "Error: The output path is a directory. Please provide a file path with a file name."
    exit 1
fi

# Execute the curl command with the provided URL and output file path
curl "$URL" --output "$OUTPUT_FILE_PATH"

# Check if the curl command was successful
if [ $? -eq 0 ]; then
    echo "File downloaded successfully to $OUTPUT_FILE_PATH"
else
    echo "Failed to download file from $URL"
    exit 1
fi