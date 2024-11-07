#! /usr/bin/env bash

function invalid_params {
    echo "Please specify the bucket and the file to upload. "
    exit 1
}

function upload_file {
    if [[ $# -ne 2 ]]
    then
        invalid_params
    fi
    bucket_name=$1
    file_name=$2
    aws s3api put-object --bucket $bucket_name --key $file_name --body $file_name
    return_code=$?
    if [[ $return_code == 0 ]]
    then
        echo "Successfully uploaded file. "
    fi
}

function main {
    if [[ $# -ne 2 ]]
    then
        invalid_params
    fi
    upload_file $1 $2
}

main "$@"
