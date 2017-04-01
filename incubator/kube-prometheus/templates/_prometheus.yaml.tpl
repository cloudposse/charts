global:
  evaluation_interval: 30s

rule_files:
  - /etc/prometheus/rules/rules-0/*.rules

scrape_configs:
- job_name: kubelets
  scrape_interval: 30s
  scrape_timeout: 10s
  scheme: https
  tls_config:
    ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
    # Skip verification until we have resolved why the certificate validation
    # for the kubelet on API server nodes fail.
    insecure_skip_verify: true
  bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token

  kubernetes_sd_configs:
  - role: node

- job_name: kube-components
  bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
  kubernetes_sd_configs:
    - role: endpoints
  relabel_configs:
    - action: replace
      source_labels: [__meta_kubernetes_service_label_k8s_app]
      target_label: job
    - action: keep
      regex: ".*-prometheus-discovery"
      source_labels: [__meta_kubernetes_service_name]
    - action: keep
      regex: "http-metrics.*|https-metrics.*"
      source_labels: [__meta_kubernetes_endpoint_port_name]
    - action: replace
      regex: "https-metrics.*"
      replacement: https
      source_labels: [__meta_kubernetes_endpoint_port_name]
      target_label: __scheme__
  tls_config:
    ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
    # API server certificates fail validation because they don't
    # include external IP address. Circumvent for now.
    insecure_skip_verify: true

- job_name: standard-endpoints
  bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
  kubernetes_sd_configs:
    - role: endpoints
  relabel_configs:
    - action: keep
      regex: prometheus-k8s|{{ template "fullname" . }}-node-exporter|{{ template "fullname" . }}-kube-state-metrics
      source_labels: [__meta_kubernetes_service_name]
    - action: replace
      source_labels: [__meta_kubernetes_service_name]
      target_label: job
  tls_config:
    ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt

