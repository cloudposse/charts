# Github Authorized Keys

Use GitHub teams to manage system user accounts and authorized_keys

Based on [Github Authorized Keys](https://github.com/cloudposse/github-authorized-keys)

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
$ helm install incubator/github-authorized-keys
```

## Introduction

This chart installs [Github Authorized Keys](https://github.com/cloudposse/github-authorized-keys) on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.
Github Authorized Keys provide user access to Kubernetes nodes based on github team membership.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Specific
**IMPORTANT:**
Because of nature of [Github Authorized Keys](https://github.com/cloudposse/github-authorized-keys)
it must be deployed as a "singleton" inside the kubernetes cluster.
For this reason, **only one release** at a time is permitted.
All additional releases will fail due to deliberate container name conflict.


## Installing the Chart

Add charts repo

```console
$ helm repo rm cloudposse-incubator 2>/dev/null
$ helm repo add cloudposse-incubator https://charts.cloudposse.com/incubator
```

We recommend to install into kube-system namespace.

To install the chart:

```console
$ helm install --namespace kube-system --name github-authorized-keys incubator/github-authorized-keys
```

We recommend to use ``github-authorized-keys`` as release name.

The command deploys Github Authorized Keys on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `github-authorized-keys` deployment:

```console
$ helm delete --purge github-authorized-keys
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the Drupal chart and their default values.

 Parameter                | Description                                                         | Default                                                                                  |
 -------------------------| ------------------------------------------------------------------- | ---------------------------------------------------------------------------------------- |
 `image.repository`       | Github Authorized Keys image repository                             | `cloudposse/github-authorized-keys`                                                      |
 `image.tag`              | Github Authorized Keys image tag                                    | `latest`                                                                                 |
 `image.pullPolicy`       | Github Authorized Keys image pull policy                            | `Always`                                                                                 |
 `githubAPIToken`         | Github api token                                                    | **REQUIRED TO BE SPECIFIED**                                                             |
 `githubOrganization`     | Github organization                                                 | **REQUIRED TO BE SPECIFIED**                                                             |
 `githubTeam`             | Github team                                                         | **REQUIRED TO BE SPECIFIED**                                                             |
 `githubTeamID`           | Github team id                                                      | **REQUIRED TO BE SPECIFIED**                                                             |
 `syncUsersGID`           | Users primary group id                                              | ``                                                                                       |
 `syncUsersGroups`        | Users secondary groups names (comma separated)                      | ``                                                                                       |
 `syncUsersShell`         | Users shell                                                         | `/bin/bash`                                                                              |
 `syncUsersInterval`      | Sync users interval in seconds                                      | `300`                                                                                    |
 `etcdEnabled`            | Enable etcd fallback cache (read more [Etcd fallback cache])        | `false`                                                                                  |
 `etcdClusterSize`        | Etcd cache node count                                               | `3`                                                                                      |
 `etcdTTL`                | Etcd cache ttl in seconds                                           | `86400`                                                                                  |
 `tplLinuxUserAdd`        | Template of create user command                                     | `adduser {username} --disabled-password --force-badname --shell {shell}`                 |
 `tplLinuxUserAddWithGid` | Template of create user with specified primary group id command     | `adduser {username} --disabled-password --force-badname --shell {shell} --group {group}` |
 `tplLinuxUserAddToGroup` | Template of add user secondary group command                        | `adduser {username} {group}`                                                             |
 `tplLinuxUserDelete`     | Template of user delete command                                     | `deluser {username}`                                                                     |
 `tplSSHRestart`          | Template of ssh restart command                                     | `/usr/sbin/service ssh force-reload`                                                     |

The above parameters map to the env variables defined in [cloudposse/github-authorized-keys](https://hub.docker.com/r/cloudposse/github-authorized-keys/).
For more information please refer to the [cloudposse/github-authorized-keys](https://github.com/cloudposse/github-authorized-keys) image and application documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name github-authorized-keys \
  --set githubAPIToken=XXX,githubOrganization=cloudposse,githubTeam=devops \
    incubator/github-authorized-keys
```

The above command sets the github token id, organization and team to `XXX`, `cloudposse` and `devops` respectively.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name github-authorized-keys -f values.yaml incubator/github-authorized-keys
```

> **Tip**: You can use the default [values.yaml](values.yaml)


## Etcd fallback cache

In case of any problems with availability of [github.com](https://github.com) github authorized keys can use
etcd build-in cluster as fallback cache. It use fallback cache only for ssh authentication.


**WARNING:** If you want to use the build-in fallback cache you have to install
[etcd-operator](https://github.com/kubernetes/charts/tree/master/stable/etcd-operator) previously.
Use next command for do this
 ```
 $ helm install stable/etcd-operator
 ```

To enable this feature you need to set true ``etcdEnabled`` variable.
Also you can specify size of the built-in etcd cluster by defining the ``etcdClusterSize`` variable.
Set the ``etcdTTL`` option to the number of seconds the cached data should be persisted before being expired and purged from the cache.
From functional point of view this is time between last successful login and last guaranteed login
(even if there is problem with connection to github.com).
