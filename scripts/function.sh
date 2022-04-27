#!/bin/bash
# Environment variables:
# LINECOUNT
# OUTPUT_BUCKET

handler () {
    set -e

    # Event Data is sent as the first parameter
    EVENT_DATA=$1

    S3_BUCKET=$(echo "$EVENT_DATA" | jq '.Records[0].s3.bucket.name'  | tr -d \")
    FILENAME=$(echo "$EVENT_DATA" | jq '.Records[0].s3.object.key' | tr -d \")

    # Start processing here
    INFILE=s3://"${S3_BUCKET}"/"${FILENAME}"
    OUTFILE=s3://"${OUTPUT_BUCKET}"/"${FILENAME%%.*}"
    
    echo "From: ${INFILE}"
    echo "To: ${OUTFILE}"
    echo "Line count: ${LINECOUNT}"

    aws s3 cp "${INFILE}" - | split -d -l "${LINECOUNT}" --filter "aws s3 cp - \"${OUTFILE}_\$FILE.csv\" | echo \"\$FILE.csv\""

    # This is the return value because it's being sent to stderr (>&2)
    echo "{\"success\": true}" >&2
}
