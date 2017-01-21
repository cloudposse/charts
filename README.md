# kube-prometheus-chart

[Helm](http://helm.sh/) chart for installing end-to-end [Prometheus](https://prometheus.io/) monitoring of [Kubernetes](https://kubernetes.io/) clusters using the [kube-prometheus](https://github.com/coreos/kube-prometheus) & [prometheus-operator](https://github.com/coreos/prometheus-operator) projects from [CoreOS](https://coreos.com/).

**As the upstream projects are very much in an alpha state, so is this one. Everything is subject to change.**

## Components
- [kube-prometheus](https://github.com/coreos/kube-prometheus): main chart
- [prometheus-operator](https://github.com/coreos/prometheus-operator): stand-alone chart, also dependency of `kube-prometheus`

## Installation
1. Package `prometheus-operator` & move to `kube-operator/charts`:
  ```console
  helm package prometheus-operator
  mv prometheus-operator-<version>.tgz kube-prometheus/charts
  ```

2. (Optional) Create a copy of `kube-prometheus/values.yaml` and customize as desired:
  ```console
  cp kube-prometheus/values.yaml custom-values.yaml
  ```

3. Package & install `kube-prometheus`:
  ```console
  helm package kube-prometheus
  helm install kube-prometheus-<version>.tgz [-f custom-values.yaml]
  ```

4. After Helm has installed the chart, execute the command displayed on screen:
  ```console
  bash -c 'cat <<EOF | kubectl create -f -
  <YAML>
  EOF'
  ```

## TODO
- [ ] Allow customization of Grafana (access control in particular)
- [ ] Enable etcd discovery & monitoring
- [ ] Enable cleanup of PVCs
- Documentation
 - [ ] Cluster/component prerequisites
 - [ ] ServiceMonitor configuration
