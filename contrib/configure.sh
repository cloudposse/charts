#!/usr/bin/env bash
CHART_URL=https://charts.cloudposse.com

## configure stable repo
helm repo rm cloudposse-stable 2>/dev/null
helm repo add cloudposse-stable  ${CHART_URL}/stable

## configure incubator repo
helm repo rm cloudposse-incubator 2>/dev/null
helm repo add cloudposse-incubator  ${CHART_URL}/incubator

## Update index
helm repo update

## display configured repos
helm repo list
