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
1. Add & update `opsgoodness` chart repository:
  ```console
  helm repo add opsgoodness http://charts.opsgoodness.com`
  helm repo update
  ```
2. (Optionally) create custom `prometheus-operator` values file
3. Install `prometheus-operator`: `helm install opsgoodness/prometheus-operator [--namespace <namespace>] [-f prometheus-operator.yaml]`
4. (Optionally) create custom `kube-prometheus` values
5. Install `kube-prometheus`: `helm install opsgoodness/kube-prometheus [--namespace <namespace>] [-f kube-prometheus.yaml]`

The `prometheus` and `alertmanager` charts may also be used independently, providing the Prometheus Operator has already been installed to the cluster.
