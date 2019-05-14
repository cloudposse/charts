# Fluentd AWS

Helm chart to run [fluentd](https://www.fluentd.org/) on kubernetes and connect to
an AWS Elasticsearch domain protected by IAM.

## Use cases

This specialized chart covers the case where:
- your Kubernetes cluster has RBAC enabled
- you are using [`kiam`](https://github.com/uswitch/kiam) to assign IAM roles to pods
- you have an [AWS Elasticsearch](https://aws.amazon.com/elasticsearch-service/)
- you have created an IAM role that has access to Elasticsearch
- you want Fluentd to collect logs from your Kubernetes cluster and forward them to Elasticsearch.

## Credit

This chart is based on [fluentd-daemonset-elasticsearch-rbac.yaml](https://github.com/fluent/fluentd-kubernetes-daemonset/blob/8c76f51/fluentd-daemonset-elasticsearch-rbac.yaml)

#### Quick start
```
helm install incubator/fluentd-kubernetes-aws \
    --set elasticsearch.endpoint=<elasticsearch_domain_endpoint> \
    --set role=<IAM role>
```

#### Full config

This chart installs the [fluentd-kubernetes-daemonset](https://github.com/fluent/fluentd-kubernetes-daemonset)
that is specialied to forward logs to Elasticsearch. That installation is entirely configured
with environment variables which are not specifcially documented, but are well named
and can be found by inspecting the templates at https://github.com/fluent/fluentd-kubernetes-daemonset/tree/8c76f51/templates

Those values can be set using `env.NAME=value`

Example `values.yaml` file:
```yaml
image: 
  repository: fluent/fluentd-kubernetes-daemonset
  tag: v1.3.3-debian-elasticsearch-1.8

role: elasticsearch-user

elasticsearch:
  endpoint: my-elasticsearch-jivhavxbcd5dvcbjzrac7j42rm.us-west-2.es.amazonaws.com
  
env:
  FLUENT_ELASTICSEARCH_RELOAD_CONNECTIONS: false
  FLUENT_ELASTICSEARCH_BUFFER_FLUSH_INTERVAL: 10s
```
