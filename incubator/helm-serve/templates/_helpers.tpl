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
{{- define "server_url" -}}
{{- if empty .Values.url -}}
{{- if .Values.service.externalPort | quote | eq "443" }}
https://{{ template "fullname" . }}.{{ .Release.Namespace }}
{{- else -}}
http://{{ template "fullname" . }}.{{ .Release.Namespace }}:{{ .Values.service.externalPort }}
{{- end -}}
{{- else -}}
{{ .Values.url }}
{{- end -}}
{{- end -}}
