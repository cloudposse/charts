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
Create a default fully qualified host name for influxdb
We truncate at 24 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "influxdb_fullname" -}}
{{- printf "%s-%s" .Release.Name "influxdb" | trunc 24 -}}
{{- end -}}
{{/*
Use `_SERVICE_HOST` env to work around bug that affects alpine images not able to use search-domain
*/}}
{{- define "influxdb_env_host" -}}
{{- printf "%s_%s" .Release.Name "influxdb" | trunc 24 | upper | printf "%s_SERVICE_HOST" -}}
{{- end -}}
