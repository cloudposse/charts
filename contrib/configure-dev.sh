#!/usr/bin/env bash
CHART_URL=https://charts.dev.cloudposse.com
BRANCH=$(git rev-parse --abbrev-ref HEAD)
## configure stable repo
helm repo rm cloudposse-stable 2>/dev/null
helm repo add cloudposse-stable  ${CHART_URL}/${BRANCH}/stable/

## configure incubator repo
helm repo rm cloudposse-incubator 2>/dev/null
helm repo add cloudposse-incubator  https://${CHART_URL}/${BRANCH}/incubator/

## Update index
helm repo update

## display configured repos
helm repo list
