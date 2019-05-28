# Kubernetes => Route53 Mapping Service

This is a Kubernetes `DaemonSet` which runs on the master node(s) and polls services and ingresses
(in all namespaces) that are configured with the label `dns=route53` and
adds the appropriate `ALIAS` to the domain specified by the annotation `domainName=sub.mydomain.io`.
Multiple domains and top level domains are also supported: `domainName=.mydomain.io,sub1.mydomain.io,sub2.mydomain.io`

It is based on [route53-kubernetes](https://github.com/cloudposse/route53-kubernetes).

## Table of Contents

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [Quick start](#quick-start)
- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Installing the Chart](#installing-the-chart)
- [Uninstalling the Chart](#uninstalling-the-chart)
- [Configuration](#configuration)
- [Usage](#usage)
  - [Service Configuration](#service-configuration)
  - [Ingress Configuration](#ingress-configuration)
- [AWS Permissions](#aws-permissions)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

----

## Quick start

```console
$ helm repo rm cloudposse-incubator 2>/dev/null
$ helm repo add cloudposse-incubator https://charts.cloudposse.com/incubator/
$ helm install cloudposse-incubator/route53-kubernetes
```

## Introduction

This chart installs [Route53-kubernetes](https://github.com/cloudposse/route53-kubernetes) on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

Add charts repo

```console
$ helm repo rm cloudposse-incubator 2>/dev/null
$ helm repo add cloudposse-incubator https://charts.cloudposse.com/incubator/
```

We recommend to install into `kube-system` namespace.

To install the chart:

```console
$ helm install --namespace kube-system --name route53 cloudposse-incubator/route53-kubernetes
```

The command deploys route53-kubernetes on the Kubernetes cluster in the default configuration.
The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `route53` deployment:

```console
$ helm delete --purge route53
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the chart and their default values.

 Parameter                   | Description                          | Default                                          |
 ----------------------------| -------------------------------------| ------------------------------------------------ |
 `dns_record_type`           | DNS resource type ( CNAME / A )      | `CNAME`                                          |
 `dns_record_ttl`            | DNS resouce ttl                      | `300`                                            |
 `ingress_service_selector`  | Selector to service used for ingress | `k8s-addon=gateway-nginx-ingress.addons.k8s.io`  |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name route53 \
    --set dns_record_type=A \
    incubator/route53-kubernetes
```

The above command sets the host parameter to 'test.com' and install vpn acceptable with that host.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name vpn -f values.yaml incubator/openvpn
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Usage

To create new dns records in route53 service you need to create k8s service or ingress
with appropriate label and annotations

### Service Configuration

Given the following Kubernetes service definition:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-app
  labels:
    app: my-app
    role: web
    dns: route53
  annotations:
    domainName: "test.mydomain.com"
    dnsRecordType: "CNAME"
    dnsRecordTTL: 600
spec:
  selector:
    app: my-app
    role: web
  ports:
  - name: web
    port: 80
    protocol: TCP
    targetPort: web
  - name: web-ssl
    port: 443
    protocol: TCP
    targetPort: web-ssl
  type: LoadBalancer
```

A "CNAME" record for `test.mydomain.com` will be created points to the ELB that is
configured by kubernetes. This assumes that a hosted zone exists in Route53 for `mydomain.com`.
Any record that previously existed for that dns record will be updated.

``dnsRecordType`` and ``dnsRecordTTL`` annotations are optional.

### Ingress Configuration

Given the following Kubernetes ingress definition:

```yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: test-ingress
  labels:
    dns: route53
  annotations:
    domainName: "test.mydomain.com"
    dnsRecordType: "A"
    dnsRecordTTL: 300
spec:
  backend:
    serviceName: testsvc
    servicePort: 80
```

An "A" record for `test.mydomain.com` will be created as an alias to the ELB that is used by
ingress controller service by kubernetes. This assumes that a hosted zone exists in Route53 for `mydomain.com`.
Any record that previously existed for that dns record will be updated.

``dnsRecordType`` and ``dnsRecordTTL`` annotations are optional.

## AWS Permissions

Because this deamonset runs on master node there is nothing additional to config about aws permissions.

But it is still good to know that this service expects that it's running on a Kubernetes node on AWS and that the IAM profile for
that node is set up to allow the following, along with the default permissions needed by Kubernetes:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "route53:ListHostedZonesByName",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "elasticloadbalancing:DescribeLoadBalancers",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "route53:ChangeResourceRecordSets",
            "Resource": "*"
        }
    ]
}
```
