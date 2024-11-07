#! /usr/bin/env bash

# Specify how many results (bucket names) to show:
TOP_ROWS=2

function list_all_buckets_numbered {
    echo "ALL my buckets (numbered): "
    advise_user
    aws s3api list-buckets --query Buckets[*].Name | tr '\t' '\n' | nl
}

function list_buckets_order_ellipsis {
    echo "My latest buckets (top $TOP_ROWS, ... if more): "
    ellipsis=0
    advise_user
    num_buckets=$(fetch_buckets | wc -l)
    limit_results
    if [[ $num_buckets > $TOP_ROWS ]]
    then 
        ellipsis=1
    fi
    if [[ $ellipsis ]]
    then
        echo "..."
    fi
}

function fetch_buckets {
    aws s3api list-buckets --output json \
    | jq '.Buckets | sort_by(.CreationDate) | reverse | .[].Name'
}

function list_buckets_order {
    echo "My latest buckets (top $TOP_ROWS): "
    advise_user
    limit_results
}

function limit_results {
    fetch_buckets | head -$TOP_ROWS
}

function test_jq {
    jq --version &>/dev/null
    return_code=$?
    if [[ $return_code != 0 ]]
    then
        echo "Utility jq is needed to run this script. Try: choco install jq "
        exit 3
    fi
}

function advise_user {
    echo "Fetching buckets. This may take a couple of seconds... "
}

function main {
    test_jq
    list_all_buckets_numbered
    echo 
    list_buckets_order
    echo 
    list_buckets_order_ellipsis
}

main 
