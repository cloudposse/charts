#!/usr/bin/env bash
## configure stable repo
helm repo rm cloudposse-stable 2>/dev/null
helm repo add cloudposse-stable  https://cloudposse-charts.s3.amazonaws.com/stable/

## configure incubator repo
helm repo rm cloudposse-incubator 2>/dev/null
helm repo add cloudposse-incubator  https://cloudposse-charts.s3.amazonaws.com/incubator/

## display configured repos
helm repo list
