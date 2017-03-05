# kube-prometheus-charts

[Helm](http://helm.sh/) charts for installing end-to-end [Prometheus](https://prometheus.io/) monitoring of [Kubernetes](https://kubernetes.io/) clusters using the [kube-prometheus](https://github.com/coreos/kube-prometheus) & [prometheus-operator](https://github.com/coreos/prometheus-operator) projects from [CoreOS](https://coreos.com/).

**As the upstream projects are very much in an alpha state, so is this one. Everything is subject to change.**

## Components
This repository contains four interrelated charts:
- `kube-prometheus`: installs end-to-end cluster monitoring
- `prometheus-operator`: installs the Prometheus Operator
- `prometheus`: installs a Prometheus instance using the Prometheus Operator
- `alertmanager`: installs an Alertmanager instance using the Prometheus Operator

## Installation
1. Package `prometheus-operator`, (optionally) create custom values file, and install to cluster:
  ```console
  helm package prometheus-operator

  cp prometheus-operator/values.yaml prometheus-operator.yaml
  vim prometheus-operator.yaml

  helm install prometheus-operator-<version>.tgz [--namespace <namespace>] [-f prometheus-operator.yaml]
  ```

2. Package `kube-prometheus`, (optionally) create custom values file, and install to cluster:
  ```console
  helm package kube-prometheus

  cp kube-prometheus/values.yaml kube-prometheus.yaml
  vim kube-prometheus.yaml

  helm install kube-prometheus-<version>.tgz [--namespace <namespace>] [-f kube-prometheus.yaml]
  ```

The `prometheus` and `alertmanager` charts may also be used independently, providing the Prometheus Operator has already been installed to the cluster.
