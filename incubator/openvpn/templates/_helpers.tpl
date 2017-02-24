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
Create a default fully qualified proxy name.
We truncate at 24 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "fullname_proxy" -}}
{{- printf "%s-%s" .Release.Name "proxy" | trunc 24 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified ssl terminator name.
We truncate at 24 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "fullname_terminator" -}}
{{- printf "%s-%s" .Release.Name "terminator" | trunc 24 | trimSuffix "-" -}}
{{- end -}}


{{/*
Create a default fully qualified let's encrypt name.
We truncate at 24 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "fullname_letsencrypt" -}}
{{- printf "%s-%s" .Release.Name "letsencrypt" | trunc 24 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified dashboard name.
We truncate at 24 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "fullname_dashboard" -}}
{{- printf "%s-%s" .Release.Name "dashboard" | trunc 24 | trimSuffix "-" -}}
{{- end -}}


{{/*
Define openvpn exposed port.

If UI and ssl enabled -> 443,
else if only UI enabled -> 80
else openvpn service external port.
*/}}
{{- define "exposed_port" -}}
{{- if (and .Values.ui.enabled .Values.ui.ssl.enabled) -}}
443
{{- else -}}
{{- if .Values.ui.enabled -}}
80
{{- else -}}
{{- .Values.openvpn.service.externalPort -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Define openvpn upstream for proxy.

If UI and ssl enabled point to ssl terminator service
else to dashboard service.
*/}}
{{- define "openvpn_proxy_upstream" -}}
{{- if (and .Values.ui.enabled .Values.ui.ssl.enabled) -}}
{{- template "fullname_terminator" . }}.{{ .Release.Namespace }}:{{ .Values.ssl_terminator.service.http.externalPort -}}
{{- end -}}
{{- end -}}

{{/*
Define openvpn port share command option.
If UI and ssl enabled point to ssl terminator service
else if ui only enabled to dashboard service
else empty.
*/}}
{{- define "openvpn_share_port" -}}
{{- if .Values.ui.enabled -}}
{{- if .Values.ui.ssl.enabled -}}
-e "port-share {{ template "fullname_terminator" . }} {{ .Values.ssl_terminator.service.https.externalPort }}"
{{- else -}}
-e "port-share localhost {{ .Values.oauth.service.http.externalPort }}"
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Define let's encrypt serivce endpoint.
*/}}
{{- define "letsencrypt_endpoint" -}}
{{- template "fullname_letsencrypt" . -}}.{{- .Release.Namespace -}}:{{ .Values.letsencrypt.service.externalPort }}
{{- end -}}

{{/*
Define host let's encrypt get certificate for.
*/}}
{{- define "letsencrypt_host" -}}
{{- .Values.host -}}
{{- end -}}

{{/*
Define dashboard serivce endpoint.
*/}}
{{- define "dashboard_endpoint" -}}
{{- template "fullname_dashboard" . }}.{{ .Release.Namespace -}}:{{ .Values.dashboard.service.externalPort }}
{{- end -}}

{{/*
Define secret to store let's encrypt certificates.
*/}}
{{- define "letsencrypt_secret" -}}
{{- .Values.ui.ssl.secret }}
{{- end -}}

{{/*
Define deployments that should be restarted after let's encrypt get new certificate.
*/}}
{{- define "letsencrypt_deployments" -}}
{{- template "fullname_terminator" . -}}
{{- end -}}

{{/*
Define let's encrypt certificate authorized center.
*/}}
{{- define "letsencrypt_ca" -}}
{{- if .Values.ui.ssl.prod -}}
https://acme-v01.api.letsencrypt.org/directory
{{- else -}}
https://acme-staging.api.letsencrypt.org/directory
{{- end -}}
{{- end -}}


{{/*
Create a default fully qualified oauth2 proxy name.
We truncate at 24 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "fullname_oauth2_proxy" -}}
{{- printf "%s-%s" .Release.Name "oauth2-proxy" | trunc 24 | trimSuffix "-" -}}
{{- end -}}