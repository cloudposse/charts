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
Create a default fully qualified dashboard name.
We truncate at 24 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "fullname_dashboard" -}}
{{- printf "%s-dashboard" .Release.Name| trunc 24 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified oauth name.
We truncate at 24 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "fullname_oauth" -}}
{{- printf "%s-oauth" .Release.Name| trunc 24 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified proxy name.
We truncate at 24 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "fullname_proxy" -}}
{{- printf "%s-proxy" .Release.Name | trunc 24 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified ssl terminator name.
We truncate at 24 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "fullname_terminator" -}}
{{- printf "%s-terminator" .Release.Name | trunc 24 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified let's encrypt name.
We truncate at 24 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "fullname_letsencrypt" -}}
{{- printf "%s-letsencrypt" .Release.Name | trunc 24 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified internal name.
We truncate at 24 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "fullname_internal" -}}
{{- printf "%s-internal" .Release.Name | trunc 24 | trimSuffix "-" -}}
{{- end -}}


{{/*
Define let's encrypt serivce endpoint.
*/}}
{{- define "letsencrypt_endpoint" -}}
{{- template "fullname_letsencrypt" . -}}:{{ .Values.letsencrypt.service.externalPort }}
{{- end -}}

{{/*
Define terminator serivce endpoint.
*/}}
{{- define "terminator_endpoint" -}}
{{- template "fullname_terminator" . }}:{{ .Values.ssl_terminator.service.http.externalPort -}}
{{- end -}}

{{/*
Create a default fully qualified oauth2 proxy name.
We truncate at 24 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "fullname_ui_endpoint" -}}
{{ template "fullname_internal" . }}:8080
{{- end -}}


{{/*
Define openvpn exposed port.

If UI and ssl enabled -> 443,
else if only UI enabled -> 80
else openvpn service external port.
*/}}
{{- define "exposed_port" -}}
{{- if .Values.ui.ssl.enabled -}}
443
{{- else -}}
{{ .Values.openvpn.service.externalPort }}
{{- end -}}
{{- end -}}

{{/*
Define openvpn port share command option.
If UI and ssl enabled point to ssl terminator service
else if ui only enabled to dashboard service
else empty.
*/}}
{{- define "openvpn_share_port" -}}
{{- if .Values.ui.ssl.enabled -}}
-e "port-share {{ template "fullname_terminator" . }} {{ .Values.ssl_terminator.service.https.externalPort }}"
{{- else -}}
-e "port-share localhost 8080"
{{- end -}}
{{- end -}}


{{/*
Define host let's encrypt get certificate for.
*/}}
{{- define "letsencrypt_host" -}}
{{- .Values.host -}}
{{- end -}}


{{/*
Define secret to store let's encrypt certificates.
*/}}
{{- define "letsencrypt_secret" -}}
{{- .Values.ui.ssl.secret }}
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
Define dashboard html secret.
*/}}
{{- define "dashboard_html_secret" -}}
{{- if  eq .Values.ui.htmlConfigmap "default" -}}
{{ template "fullname_dashboard" . }}-ui
{{- else -}}
{{ .Values.ui.htmlConfigmap }}
{{- end -}}
{{- end -}}