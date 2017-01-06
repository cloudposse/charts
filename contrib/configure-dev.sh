#!/usr/bin/env bash
BRANCH=$(git rev-parse --abbrev-ref HEAD)
## configure stable repo
helm repo rm cloudposse-stable 2>/dev/null
helm repo add cloudposse-stable  https://cloudposse-dev-charts.s3.amazonaws.com/$BRANCH/stable/

## configure incubator repo
helm repo rm cloudposse-incubator 2>/dev/null
helm repo add cloudposse-incubator  https://cloudposse-dev-charts.s3.amazonaws.com/$BRANCH/incubator/

## display configured repos
helm repo list
