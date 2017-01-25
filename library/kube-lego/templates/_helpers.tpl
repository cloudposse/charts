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
Compute the Lego URL depnding on if we're in a prod/staging environment
*/}}
{{- define "lego_url" -}}
{{- if .Values.lego.prod -}}
{{-   printf "https://acme-v01.api.letsencrypt.org/directory" -}}
{{- else -}}
{{-   printf "https://acme-staging.api.letsencrypt.org/directory" -}}
{{- end -}}
{{- end -}}
