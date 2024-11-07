#! /usr/bin/env bash

function newest_bucket {
    aws s3api list-buckets --output json \
    | jq '.Buckets | sort_by(.CreationDate) | reverse | .[].Name' | head -1
}

function explore_newest_bucket {
    latest_bucket=$(newest_bucket | tr -d '"')
    aws s3api list-objects-v2 --bucket $latest_bucket
}

function advise_user {
    echo "Fetching bucket. This may take a couple of seconds... "
}

function main {
    advise_user
    latest_bucket=$(newest_bucket)
    echo "Latest bucket: ${latest_bucket} "
    echo 
    advise_user
    contents=$(explore_newest_bucket)
    echo "Latest bucket contains: $contents "
}

main
