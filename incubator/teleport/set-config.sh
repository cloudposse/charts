#!/bin/bash
set -e

if [ "$#" -ne 2 ]; then
    echo "usage: set-config.sh [key] [value]"
    echo "example: set-config.sh auth_token \"48374897\""
    exit 1
fi

if [ -z ${CLUSTER} ]; then
    echo "CLUSTER is not set"
    exit 1
fi

aws ssm put-parameter --overwrite --name "/platform/charts/teleport/${CLUSTER}/${1}" --region ${AWS_REGION} --type SecureString --value "$2"
