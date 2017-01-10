#!/usr/bin/env bash
REPO_URL=${REPO_URL:-https://charts.dev.cloudposse.com}

if [ -n "${TRAVIS_PULL_REQUEST_BRANCH}" ]; then
  BRANCH="pr-${TRAVIS_PULL_REQUEST_BRANCH}"
elif [ -n "${TRAVIS_BRANCH}" ]; then
  BRANCH="${TRAVIS_BRANCH}"
elif [ -n "${TRAVIS_TAG}" ]; then
  BRANCH="${TRAVIS_TAG}"
else
  BRANCH="$(git rev-parse --abbrev-ref HEAD)"
fi

## configure stable repo
helm repo rm cloudposse-dev-stable 2>/dev/null
helm repo add cloudposse-dev-stable ${REPO_URL}/${BRANCH}/stable

## configure incubator repo
helm repo rm cloudposse-dev-incubator 2>/dev/null
helm repo add cloudposse-dev-incubator ${REPO_URL}/${BRANCH}/incubator

## Update index
helm repo update

## display configured repos
helm repo list
