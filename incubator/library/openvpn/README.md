# OpenVPN

Use [OpenVPN](https://openvpn.net) to access kubernetes cluster resources

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
$ helm repo add cloudposse-incubator http://charts.cloudposse.com/incubator/packages/
$ helm install --set host={host} incubator/openvpn
```

## Introduction

This chart installs [OpenVPN](https://openvpn.net) on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

### Features

 1) OpenVPN
 2) VPN authorization based on Github credentials using [Github-PAM](https://github.com/cloudposse/github-pam)
 3) UI to get generated generated vpn client config
 4) HTTPS for UI based on [Let's encrypt](https://letsencrypt.org/)

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure
- [Route53 mapper](https://github.com/cloudposse/charts/tree/master/incubator/library/route53-mapping)


## Installing the Chart

Add charts repo

```console
$ helm repo rm cloudposse-incubator 2>/dev/null
$ helm repo add cloudposse-incubator http://charts.cloudposse.com/incubator/packages/
```

We recommend to install into kube-system namespace.

To install the chart:

```console
$ helm install --namespace kube-system --name vpn incubator/openvpn
```

The command deploys OpenVPN on the Kubernetes cluster in the default configuration.
The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `vpn` deployment:

```console
$ helm delete --purge vpn
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the OpenVPN chart and their default values.

 Parameter         | Description                                 | Default                                             |
 ------------------| ------------------------------------------- | --------------------------------------------------- |
 `host`            | VPN gateway host                            | **REQUIRED TO BE SPECIFIED**                        |
 `secret`          | Secret name to store openvpn certificates   / `openvpn-secret`                                    |
 `ui.enabled`      | Enable UI                                   | `true`                                              |
 `ui.ssl.enabled`  | Use https for UI                            | `false`                                             |
 `ui.ssl.prod`     | Use production ready ssl certificate        | `false`                                             |
 `ui.ssl.email`    | Email for notifications                     | **REQUIRED TO BE SPECIFIED** if ui.ssl.enabled=true |
 `ui.ssl.secret`   | Secret name to store ssl certificates       | `openvpn-letsencrypt-secret`                        |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name vpn \
  --set host=test.com \
    incubator/openvpn
```

The above command sets the host parameter to 'test.com' and install vpn acceptable with that host.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name vpn -f values.yaml incubator/openvpn
```

> **Tip**: You can use the default [values.yaml](values.yaml)

> **Tip**: We expose with table only user meaningful options. Developers could find much more options in [values.yaml](values.yaml)

## Github authorization support

