{{- if .Values.config }}
{{ .Values.config }}
{{- else }}
global:
  resolve_timeout: 5m
receivers:
  - name: 'webhook'
    webhook_configs:
      - url: 'http://alertmanagerwh:30500/'
route:
  group_by: ['job']
  group_interval: 5m
  group_wait: 30s
  receiver: 'webhook'
  repeat_interval: 12h
{{- end }}