{{/*
Create a default fully qualified mixer name.
*/}}
{{- define "dashboard.mixer.name" -}}
{{- $diff := dict "nameOverride" "mixer" | dict "Values" -}}
{{- $values := merge $diff . -}}
{{- include "common.name" $values -}}
{{- end -}}

{/*
Create a default fully qualified mixer name.
*/}}
{{- define "dashboard.mixer.fullname" -}}
{{- $base := default (printf "%s-%s" .Release.Name "mixer") .Values.mixer.fullnameOverride -}}
{{- $diff := dict "fullnameOverride" $base | dict "Values" -}}
{{- $values := merge $diff . -}}
{{- template "common.fullname" $values -}}
{{- end -}}

{{- /*
dashboard.mixer.labels.standard prints the standard Helm labels for mixer.

The standard labels are frequently used in metadata.
*/ -}}
{{- define "dashboard.mixer.labels.standard" -}}
app: {{ template "dashboard.mixer.name" . }}
chart: {{ template "common.chartref" . }}
heritage: {{ .Release.Service | quote }}
release: {{ .Release.Name | quote }}
{{- end -}}

