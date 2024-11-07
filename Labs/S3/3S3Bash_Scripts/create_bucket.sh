#! /usr/bin/env bash

REGION="us-east-2"


function advise_user {
    echo "Creating bucket. This may take a couple of seconds... "
}

function create_bucket {
    if [[ $# -ne 1 ]]
    then
        bucket_name_missing
    fi
    advise_user
    bucket_name=$1
    aws s3api create-bucket --bucket $bucket_name \
    --create-bucket-configuration LocationConstraint=$REGION
    return_code=$?
    if [[ $return_code == 0 ]]
    then
        region=$(aws s3api get-bucket-location --bucket $bucket_name)
        echo "Successfully created the new bucket in region $region! "
    else
        exit $return_code
    fi
}

function bucket_name_missing {
    echo "Please specify the name of the new bucket. " >&2
    exit 1
}

function main {
    if [[ $# -ne 1 ]]
    then
        bucket_name_missing
    fi
    create_bucket $1
}

main "$@"

