{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 24 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 24 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 24 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 24 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "fullname_proxy" -}}
{{- printf "%s-%s" .Release.Name "proxy" | trunc 24 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 24 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "fullname_terminator" -}}
{{- printf "%s-%s" .Release.Name "terminator" | trunc 24 | trimSuffix "-" -}}
{{- end -}}


{{/*
Create a default fully qualified app name.
We truncate at 24 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "fullname_letsencrypt" -}}
{{- printf "%s-%s" .Release.Name "letsencrypt" | trunc 24 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 24 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "fullname_dashboard" -}}
{{- printf "%s-%s" .Release.Name "dashboard" | trunc 24 | trimSuffix "-" -}}
{{- end -}}


{{/*
Create a default fully qualified app name.
We truncate at 24 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "exposed_port" -}}
{{- if (and .Values.ui.enabled .Values.ui.ssl.enabled) -}}
443
{{- else -}}
{{- if .Values.ui.enabled -}}
80
{{- else -}}
{{ .Values.openvpn.service.externalPort }}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 24 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "openvpn_proxy_upstream" -}}
{{- if (and .Values.ui.enabled .Values.ui.ssl.enabled) -}}
{{- template "fullname_terminator" . }}.{{ .Release.Namespace }}:{{ .Values.ssl_terminator.service.http.externalPort -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 24 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "openvpn_share_port" -}}
{{- if .Values.ui.enabled -}}
{{- if .Values.ui.ssl.enabled -}}
-e "port-share {{ template "fullname_terminator" . }}.{{ .Release.Namespace }} {{ .Values.ssl_terminator.service.https.externalPort }}"
{{- else -}}
-e "port-share {{- template "fullname_dashboard" . }}.{{ .Release.Namespace -}} {{ .Values.dashboard.service.externalPort }}"
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a dashboard service name.
We truncate at 24 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "letsencrypt_endpoint" -}}
{{- template "fullname_letsencrypt" . -}}.{{- .Release.Namespace -}}:{{ .Values.letsencrypt.service.externalPort }}
{{- end -}}

{{/*
Create a dashboard service name.
We truncate at 24 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "letsecrypt_host" -}}
{{- .Values.host -}}
{{- end -}}

{{/*
Create a dashboard service name.
*/}}
{{- define "dashboard_endpoint" -}}
{{- template "fullname_dashboard" . }}.{{ .Release.Namespace -}}:{{ .Values.dashboard.service.externalPort }}
{{- end -}}

{{/*
Create a dashboard service name.
*/}}
{{- define "letsencrypt_secret" -}}
{{- .Values.ui.ssl.secret }}
{{- end -}}

{{/*
Create a dashboard service name.
We truncate at 24 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "letsencrypt_domains" -}}
{{- .Values.host }}
{{- end -}}

{{/*
Create a dashboard service name.
*/}}
{{- define "letsencrypt_deployments" -}}
{{- template "fullname_terminator" . -}}
{{- end -}}

{{/*
Create a dashboard service name.
*/}}
{{- define "letsencrypt_ca" -}}
{{- if .Values.ui.ssl.prod -}}
https://acme-v01.api.letsencrypt.org/directory
{{- else -}}
https://acme-staging.api.letsencrypt.org/directory
{{- end -}}
{{- end -}}






