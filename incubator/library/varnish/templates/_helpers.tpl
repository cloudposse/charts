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
Create secret name.
*/}}
{{- define "secret_name" -}}
{{- if eq .Values.varnish.secret.name "default" -}}
{{ template "fullname" . }}
{{- else -}}
{{ .Values.varnish.secret.name }}
{{- end -}}
{{- end -}}

{{/*
Create config name.
*/}}
{{- define "config_name" -}}
{{- if eq .Values.varnish.config.map "default" -}}
{{ template "fullname" . }}
{{- else -}}
{{ .Values.varnish.config.map }}
{{- end -}}
{{- end -}}