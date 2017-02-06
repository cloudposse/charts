#!/usr/bin/env bash
make helm:serve:index \
&& helm serve --address "0.0.0.0:8879" --repo-path /charts/packages

