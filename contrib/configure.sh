#!/usr/bin/env bash
REPO_URL=${REPO_URL:-https://charts.cloudposse.com}

## configure kubernetes charts
helm repo rm kubernetes-charts 2>/dev/null
helm repo add kubernetes-charts http://storage.googleapis.com/kubernetes-charts

## configure stable repo
helm repo rm cloudposse-stable 2>/dev/null
helm repo add cloudposse-stable ${REPO_URL}/stable

## configure incubator repo
helm repo rm cloudposse-incubator 2>/dev/null
helm repo add cloudposse-incubator ${REPO_URL}/incubator

## configure distro repo
helm repo rm cloudposse-distro 2>/dev/null
helm repo add cloudposse-distro ${REPO_URL}/distro

## Update index
helm repo update

## display configured repos
helm repo list
