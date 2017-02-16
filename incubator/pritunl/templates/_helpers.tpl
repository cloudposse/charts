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
Mongo db fullname
*/}}
{{- define "mongodb_fullname" -}}
{{- printf "%s-%s" .Release.Name "mongodb" | trunc 24 | trimSuffix "-" -}}
{{- end -}}

{{/*
Mongo db host
*/}}
{{- define "mongodb_host" -}}
{{- if eq .Release.Namespace "default" -}}
{{ template "mongodb_fullname" . }}
{{- else -}}
{{ template "mongodb_fullname" . }}.{{ .Release.Namespace }}
{{- end -}}
{{- end -}}

{{/*
Mongo db uri
*/}}
{{- define "mongodb_uri" -}}
mongodb://{{ template "mongodb_host" . }}:27017/pritunl
{{- end -}}