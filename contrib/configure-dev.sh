#!/usr/bin/env bash
CHART_URL=https://charts.dev.cloudposse.com
BRANCH=$(git rev-parse --abbrev-ref HEAD)
## configure stable repo
helm repo rm cloudposse-dev-stable 2>/dev/null
helm repo add cloudposse-dev-stable  ${CHART_URL}/${BRANCH}/stable/

## configure incubator repo
helm repo rm cloudposse-dev-incubator 2>/dev/null
helm repo add cloudposse-dev-incubator  https://${CHART_URL}/${BRANCH}/incubator/

## Update index
helm repo update

## display configured repos
helm repo list
