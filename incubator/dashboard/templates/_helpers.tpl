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

{/*
Create a default fully qualified oauth2-proxy name.
*/}}
{{- define "dashboard.oauth2-proxy.fullname" -}}
{{- $base := ( printf "%s-%s" .Release.Name "oauth2-proxy" ) -}}
{{- $diff := dict "fullnameOverride" $base | dict "Values" -}}
{{- $values := merge $diff . -}}
{{- template "common.fullname" $values -}}
{{- end -}}

{/*
Schema
*/}}
{{- define "dashboard.schema" -}}
{{- if .Values.ingress.tls.enabled -}}
{{- printf "https" -}}
{{- else -}}
{{- printf "http" -}}
{{- end -}}
{{- end -}}


{/*
External auth auth-url endpoint
*/}}
{{- define "dashboard.auth-url" -}}
{{- printf "%s://$host/oauth2/auth" (include "dashboard.schema" . ) -}}
{{- end -}}

{/*
External auth auth-signin endpoint
*/}}
{{- define "dashboard.auth-signin" -}}
{{- printf "%s://$host/oauth2/start" (include "dashboard.schema" . ) -}}
{{- end -}}

{/*
External auth auth-request-redirect endpoint
*/}}
{{- define "dashboard.auth-request-redirect" -}}
{{- printf "%s://$host/" (include "dashboard.schema" . ) -}}
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

