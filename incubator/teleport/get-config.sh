#!/bin/bash
set -e

if [ -z ${1} ]; then
    echo "You must provide a key to fetch from parameter store"
    exit 1
fi

if [ -z ${CLUSTER} ]; then
    echo "CLUSTER is not set"
    exit 1
fi

RESPONSE=`aws ssm get-parameter --name "/platform/charts/teleport/${CLUSTER}/${1}" --region ${AWS_REGION} --with-decryption`
echo -n $RESPONSE | jq -r .Parameter.Value
