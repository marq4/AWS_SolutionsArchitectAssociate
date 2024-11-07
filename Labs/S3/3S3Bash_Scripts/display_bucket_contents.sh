#! /usr/bin/env bash

function explore_bucket {
    if [[ $# -ne 1 ]]
    then
        bucket_name_missing
    fi
    bucket_name=$1
    advise_user
    echo "Bucket contents: "
    aws s3api list-objects-v2 --bucket $bucket_name --output json \
    --query 'Contents[*].Key'
}

function advise_user {
    echo "Fetching bucket. This may take a couple of seconds... "
}

function bucket_name_missing {
    echo "Please specify the name of the bucket to explore. "
    exit 1
}

function main {
    if [[ $# -ne 1 ]]
    then
        bucket_name_missing
    fi
    explore_bucket $1
}

main "$@"
