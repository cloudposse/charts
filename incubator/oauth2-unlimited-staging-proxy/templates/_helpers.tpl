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
Create a default fully qualified oauth name.
We limit this value to 24 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "fullname_oauth" -}}
{{- printf "%s-oauth" .Release.Name | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified proxy name.
We truncate at 24 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "fullname_proxy" -}}
{{- printf "%.17s-proxy" .Release.Name | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified proxy name.
We truncate at 24 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "fullname_ingress" -}}
{{- printf "%.16s-ingress" .Release.Name | trimSuffix "-" -}}
{{- end -}}
