#! /usr/bin/env bash

function delete_empty_bucket {
    if [[ $# -ne 1 ]]
    then
        invalid_params
    fi
    bucket_name=$1
    echo "Deleting empty bucket. This may take some time... "
    aws s3api delete-bucket --bucket $bucket_name
    return_code=$?
    if [[ $return_code == 0 ]]
    then
        echo "Successfully deleted bucket. "
    fi
}

function delete_bucket_contents {
    if [[ $# -ne 1 ]]
    then
        invalid_params
    fi
    bucket_name=$1
    read -p "Bucket contains objects. Delete them? (confirm: y) " response
    if [[ "$response" != "y" ]]
    then
        exit 0
    fi
    echo "Deleting all objects. This may take some time... "
    file_name="`date | tr -d ' ,:'`.json"
    aws s3api list-objects-v2 --bucket $bucket_name --output json \
    | jq ' { Objects: [ .Contents[] | { Key: .Key } ] } ' \
    > $file_name
    aws s3api delete-objects --bucket $bucket_name \
    --delete file://${file_name}
    return_code=$?
    if [[ $return_code == 0 ]]
    then
        echo "Deleted contents of bucket. "
    else
        exit 2
    fi
    rm -f $file_name
}

# Returns 1 if bucket exists:
function bucket_exists {
    if [[ $# -ne 1 ]]
    then
        invalid_params
    fi
    bucket_name=$1
    aws s3api head-bucket --bucket $bucket_name &>/dev/null
    return_code=$?
    if [[ $return_code != 0 ]]
    then
        echo 0
        return 0
    fi
    echo 1
}

# Returns 1 if bucket is empty:
function bucket_is_empty {
    if [[ $# -ne 1 ]]
    then
        invalid_params
    fi
    bucket_name=$1
    response=$(aws s3api list-objects-v2 --bucket $bucket_name \
    --output json)
    return_code=$?
    if [[ $return_code != 0 ]]
    then
        exit 3
    fi
    if [ -z "$response" ]
    then
        # Bucket IS EMPTY:
        echo 1
        return 1
    fi
    # Bucket has objects:
    echo 0
}

function invalid_params {
    echo "Please specify the name of the bucket to be deleted. "
    exit 1
}

function main {
    if [[ $# -ne 1 ]]
    then
        invalid_params
    fi
    bucket_name=$1
    exists=$(bucket_exists $bucket_name)
    if [[ $exists -eq 0 ]]
    then
        echo "That bucket does not exist. "
        exit 4
    fi
    empty=$(bucket_is_empty $bucket_name)
    if [[ 0 == $empty ]]
    then
        delete_bucket_contents $bucket_name
    fi
    delete_empty_bucket $bucket_name
}

main "$@"
