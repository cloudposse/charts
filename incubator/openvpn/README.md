# OpenVPN

Deploy your own [OpenVPN](https://openvpn.net) server running in Kubernetes to access internal cluster resources using GitHub backed authentication for user & group management.

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
    - [Github team based ACL](#github-team-based-acl)
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
$ helm repo add cloudposse-incubator https://charts.cloudposse.com/incubator/
$ helm install --set host={host} cloudposse-incubator/openvpn
```

## Introduction

This chart installs [OpenVPN](https://openvpn.net) on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

### Features

 1. OpenVPN
 2. VPN authorization based on Github credentials using [Github-PAM](https://github.com/cloudposse/github-pam)
 3. Simple web UI to download generated generated OpenVPN client config file
 4. HTTPS for UI based on [Let's encrypt](https://letsencrypt.org/)

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure
- [Route53 Kubernetes](https://github.com/cloudposse/charts/tree/master/incubator/library/route53-kubernetes)

## Installing the Chart

Add charts repo

```console
$ helm repo rm cloudposse-incubator 2>/dev/null
$ helm repo add cloudposse-incubator https://charts.cloudposse.com/incubator/
```

We recommend to install into kube-system namespace.

To install the chart:

```console
$ helm install --namespace kube-system --name vpn cloudposse-incubator/openvpn
```

The command deploys OpenVPN on the Kubernetes cluster in the default configuration.
The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `vpn` deployment:

```console
$ helm delete --purge vpn
```

This command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the OpenVPN chart and their default values.

 Parameter         | Description                                 | Default                                             |
 ------------------| ------------------------------------------- | --------------------------------------------------- |
 `host`            | VPN gateway hostname                        | **REQUIRED TO BE SPECIFIED**                        |
 `github_team`     | GitHub team in format {org}/{team}          | **REQUIRED TO BE SPECIFIED**                        |
 `secret`          | Secret name to store openvpn certificates   | `openvpn-secret`                                    |
 `ui.enabled`      | Enable UI                                   | `true`                                              |
 `ui.ssl.enabled`  | Use https for UI                            | `false`                                             |
 `ui.ssl.prod`     | Use production ready SSL certificate        | `false`                                             |
 `ui.ssl.email`    | Email for notifications                     | **REQUIRED TO BE SPECIFIED** if ui.ssl.enabled=true |
 `ui.ssl.secret`   | Secret name to store SSL certificates       | `openvpn-letsencrypt-secret`                        |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name vpn \
  --set host=test.com \
  --set github_team={company}/{team} \
    incubator/openvpn
```

The above command sets the host parameter to 'test.com' and install vpn acceptable with that host.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name vpn -f values.yaml incubator/openvpn
```

> **Tip**: You can use the default [values.yaml](values.yaml) for reference.

> **Tip**: We expose only the most common options in the table above. There are many more options that can be tweaked in the [values.yaml](values.yaml).

## GitHub Authorization Support

This chart use [Github PAM](https://github.com/cloudposse/github-pam) for all authorization purpose.
Everywhere you will need login\password use your github.com onces.

### GitHub Team Based ACLs

You must specify a GitHub team that should be used to control access to the VPN.
The team in format should be `{organization name}/{team name}` as value for the `github_team` parameter.

### Two-Factor Authorization

If you use Two-Factor authentication on your github.com account, then you will need to append the MFA code
to the end of your password, separated by a space.

**Example**:

Login: user1
Password: qwerty
Current MFA code: 123 456

Enter values

Login field | Password field  |
------------| ----------------|
   `user1`  | `qwerty 123456` |


## UI

There is very basic web UI which allow users to download the pre-generated OpenVPN client configuration that can be
used to import VPN connection to their client. To enable the web UI set the value of ``ui.enabled=true``. By default, the UI is enabled.

UI can be accessed at ``http://{host}``, the same `host` that you would use as the endpoint for the VPN.

### HTTPS with Let's Encrypt

If ``ui.ssl.enabled=true``, then the UI would be accessed at ``https://{host}``.
The SSL certificate will be signed by [Let's Encrypt](https://letsencrypt.org/) and be accepted by all modern web browsers.

> **WARNING:** You must specify the ``ui.ssl.email={your email}`` in order for the SSL certificates to be generated successfully.

Let's Encrypt has **HARD** [rate limits](https://letsencrypt.org/docs/rate-limits/).

Production ready certificates have low rate limits (like ~12 a day), so by default you should use the [staging certificates](https://letsencrypt.org/docs/staging-environment/) to avoid getting blocked! You've been warned.

Set ``ui.ssl.prod=true`` to enable production ready certificate.

## Using VPN

To connect to the VPN, you need to download the pre-generated client configuration and then [connect to OpenVPN](https://openvpn.net/index.php/access-server/docs/admin-guides-sp-859543150/howto-connect-client-configuration.html)

### Client Generated Config

You can download the client configuration file (``client.ovpn``) from the UI at ``http(s)://{host}``.

If the UI is disabled, then you retrieve the client configuration with the following command. It requires access to the Kubernetes API.

```console
kubectl get secret {secret} --template='{{.data.client}}' | base64 -d > client.ovpn
```

### Connect VPN

Connect to the VPN using the pre-generated client configuration ``client.ovpn``by following the
[instructions](https://openvpn.net/index.php/access-server/docs/admin-guides-sp-859543150/howto-connect-client-configuration.html) for your OS.

All propmpts for login & password will accept your github.com login & password. You can [read more here](#github-authorization-support) about how it works.


# Understanding this Chart

This is a necessarily complex chart due to some limitations of Helm, so this information can be useful for troubelshooting.

Chart consists of 4 parts

* __OpenVPN__
* __SSL Terminator__     (if ui.enabled and ui.ssl.enabled)
* __Let's Encrypt Bot__  (if ui.enabled and ui.ssl.enabled)
* __UI Dashboard__       (if ui.enabled)

Installation process several stages before vpn would became ready to use.

1) __Pre-Install Stage__
  * __OpenVPN__ generates certificates and save them to the k8s secret ``{secret}``
  * If `ui.enabled` and `ui.ssl.enabled`, then the __Let's Encrypt Bot__ generates SSL certificates and saves them to the k8s secret ``{ui.ssl.secret}``

2) __Install Stage__
  * If ui.enabled create __Dashboard__ deployment, service, configmap.
  * If ui.enabled and ui.ssl.enabled create __Let's encrypt bot__ deployment, service.
  * If ui.enabled and ui.ssl.enabled create __SSL terminator__ deployment, service.
  * Create __OpenVPN__ deployment, service (annotated for [route53-kubernetes](https://github.com/cloudposse/charts/tree/master/incubator/library/route53-kubernetes)), configmap.
3) __Post-Install Stage__
  * [route53-kubernetes](https://github.com/cloudposse/charts/tree/master/incubator/library/route53-kubernetes) adds
  DNS record that points to the __OpenVPN Service__
  * If `ui.enabled` and `ui.ssl.enabled`, then the __Let's Encrypt Bot__ waits until new DNS records are resolved
  * If `ui.enabled` and `ui.ssl.enabled`, then the __Let's Encrypt Bot__ tries to get a new certificate
  * Upon successful acquisition of new __Let's Encrypt__ certificate, then restart the __SSL Terminator Deployment__

VPN is ready for use.


