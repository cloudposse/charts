# Kube Lego

A Helm chart for kube-Lego that provides automatic signed certificates for Ingress resources in the deployed namespace.

Based on [kube-lego](https://github.com/jetstack/kube-lego) by Jetstack.

## Table of Contents

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [Quick start](#quick-start)
- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Specific](#specific)
- [Installing the Chart](#installing-the-chart)
- [Uninstalling the Chart](#uninstalling-the-chart)
- [Configuration](#configuration)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


----

## Quick start

```console
$ helm repo rm cloudposse-incubator 2>/dev/null
$ helm repo add cloudposse-incubator https://charts.cloudposse.com/incubator
$ helm install --namespace=kube-system --name kube-lego --set lego.prod=false,lego.email=hello@cloudposse.com incubator/kube-lego
```

## Introduction

This chart installs [kube-lego](https://github.com/jetstack/kube-lego) on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.
It handles the exchange between the Let's Encrypt API to generate signed SSL certificaes which get stored in Kubernetes secrets.

**IMPORTANT**
Before you begin, we recommend you become familiar with the **HARD** rate limits here: https://letsencrypt.org/docs/rate-limits/

Do not generate `prod` certificates for testing or you'll probably get rate limited! *You've been warned.*

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled

## Specific
**IMPORTANT:**
You should only deploy one `kube-lego` chart per cluster, therefore we recommend you choose the `kube-system` namespace.

## Installing the Chart

Add the charts repo

```console
$ helm repo rm cloudposse-incubator 2>/dev/null
$ helm repo add cloudposse-incubator https://charts.cloudposse.com/incubator
```

We recommend that you use the `kube-system` namespace, since there should only be one install per cluster.

To install the chart:

```console
$ helm install --namespace=kube-system --name=kube-lego incubator/kube-lego
```

We recommend to use ``kube-lego`` as the release name.

The command deploys `kube-lego` on the Kubernetes cluster with the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `kube-lego` deployment:

```console
$ helm delete --purge kube-lego
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the kube-lego chart and their default values.

 Parameter                | Description                                                         | Default                                                                                  |
 -------------------------| ------------------------------------------------------------------- | ---------------------------------------------------------------------------------------- |
 `image.repository`       | kube-lego image repository                                          | `jetstack/kube-lego`                                                                     |
 `image.tag`              | kube-lego image tag                                                 | `0.1.3`                                                                                  |
 `image.pullPolicy`       | kube-lego image pull policy                                         | `IfNotPresent`                                                                           |
 `lego.email`             | Email to associate with requests to Let's Encrypt                   | **REQUIRED TO BE SPECIFIED**                                                             |
 `lego.prod`              | Whether or not to generate signed certificates                      | `false`                                                                                  |

The above parameters map to the env variables defined in [cloudposse/kube-lego](https://hub.docker.com/r/cloudposse/kube-lego/).
For more information please refer to the [cloudposse/kube-lego](https://github.com/cloudposse/kube-lego) image and application documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install \
    --namespace kube-system
    --name kube-lego \
    --set lego.prod=false,lego.email=hello@cloudposse.com \
    incubator/kube-lego
```

The above command sets the `lego.prod` mode to false and the `lego.email` to `hello@cloudposse.com`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install \
    --namespace kube-system \
    --name kube-lego \
    -f values.yaml \
    incubator/kube-lego
```

> **Tip**: You can use the default [values.yaml](values.yaml) as template to get you started.



