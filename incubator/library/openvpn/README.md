# OpenVPN

Use [OpenVPN](https://openvpn.net) to access kubernetes cluster resources

## Table of Contents

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


  - [Quick start](#quick-start)
  - [Introduction](#introduction)
    - [Features](#features)
  - [Prerequisites](#prerequisites)
  - [Installing the Chart](#installing-the-chart)
  - [Uninstalling the Chart](#uninstalling-the-chart)
  - [Configuration](#configuration)
  - [Github authorization support](#github-authorization-support)
    - [Two-Factor authorization](#two-factor-authorization)
  - [UI](#ui)
    - [HTTPS with Let's Encrypt](#https-with-lets-encrypt)
  - [Using VPN](#using-vpn)
    - [Client generated config](#client-generated-config)
    - [Connect VPN](#connect-vpn)
- [Understand chart](#understand-chart)

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
- [Route53 Kubernetes](https://github.com/cloudposse/charts/tree/master/incubator/library/route53-kubernetes)


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
 `secret`          | Secret name to store openvpn certificates   | `openvpn-secret`                                    |
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

This chart use [Github PAM](https://github.com/cloudposse/github-pam) for all authorization purpose.
Everywhere you will need login\password use your github.com onces.

### Two-Factor authorization

If you use Two-Factor authorization on your github.com account you need to add MFA
to the end of password field, separated with password by space.

**Example**:

Login: user1
Password: qwerty
Current MFA code: 123 456

Enter values

Login field | Password field  |
------------| ----------------|
   `user1`  | `qwerty 123456` |


## UI

There is web UI allow users to get pre-generated openvpn client configuration that can be
used to import vpn connection. To enable UI set value ``ui.enabled=true``. By default UI enabled.

UI would be acceptable by url ``http://{host}``.

### HTTPS with Let's Encrypt

If ``ui.ssl.enabled=true`` UI would be acceptable by ``https://{host}``.
SSL certificate would be generated by [Let's encrypt](https://letsencrypt.org/).

> **WARNING:** You have specify ``ui.ssl.email={your email}`` to make ssl certificate be generated successfully.

Let's encrypt have [limits](https://letsencrypt.org/docs/rate-limits/).
Production ready certificates have low limits, so by default it would be [staging purpose certificate](https://letsencrypt.org/docs/staging-environment/).
Set ``ui.ssl.prod=true`` to enable production ready certificate.

## Using VPN

To connect VPN you need to get pre-generated client configuration and then [connect to openvpn](https://openvpn.net/index.php/access-server/docs/admin-guides-sp-859543150/howto-connect-client-configuration.html)

### Client generated config

You can download a connect client configuration (``client.ovpn``) from UI ``http(s)://{host}``.

If UI is disabled you can get the configuration with following command

```console
kubectl get secret {secret} --template='{{.data.client}}' | base64 -d > client.ovpn
```

### Connect VPN

Connect to VPN using the pre-generated client configuration ``client.ovpn``
following [instructions](https://openvpn.net/index.php/access-server/docs/admin-guides-sp-859543150/howto-connect-client-configuration.html)
depends of your OS.

Connection require login\password use your github.com login\password [read more](#github-authorization-support).


# Understand chart

This is quite complex chart so this information can be useful for troubelshooting.

Chart consists of 4 parts

* __OpenVPN__
* __SSL terminator__     (if ui.enabled and ui.ssl.enabled)
* __Let's encrypt bot__  (if ui.enabled and ui.ssl.enabled)
* __UI dashboard__       (if ui.enabled)

Installation process several stages before vpn would became ready to use.

1) __Pre-install stage__
  * __Open vpn__ generates certificates and save to k8s secret ``{secret}``
  * If ui.enabled and ui.ssl.enabled __Let's encrypt bot__ generates https certificates and save to k8s secret ``{ui.ssl.secret}``

2) __Install stage__
  * If ui.enabled create __Dashboard__ deployment, service, configmap.
  * If ui.enabled and ui.ssl.enabled create __Let's encrypt bot__ deployment, service.
  * If ui.enabled and ui.ssl.enabled create __SSL terminator__ deployment, service.
  * Create __OpenVPN__ deployment, service (annotated for [route53-kubernetes](https://github.com/cloudposse/charts/tree/master/incubator/library/route53-kubernetes)), configmap.
3) __After install stage__
  * [route53-kubernetes](https://github.com/cloudposse/charts/tree/master/incubator/library/route53-kubernetes) adds
  dns record point to __OpenVPN service__
  * If ui.enabled and ui.ssl.enabled __Let's encrypt bot__ waits until new dns records would be resolved
  * If ui.enabled and ui.ssl.enabled __Let's encrypt bot__ tries to get new certificate
  * On success getting new __Let's encrypt__ certificate restart  __SSL terminator deployment__

VPN ready for use.


