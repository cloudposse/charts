{{/*
Create a default fully qualified proxy name.
*/}}
{{- define "portal.proxy.name" -}}
{{- $diff := dict "nameOverride" "proxy" | dict "Values" -}}
{{- $values := merge $diff . -}}
{{- include "common.name" $values -}}
{{- end -}}

{/*
Create a default fully qualified proxy name.
*/}}
{{- define "portal.proxy.fullname" -}}
{{- $base := default (printf "%s-%s" .Release.Name "proxy") .Values.proxy.fullnameOverride -}}
{{- $diff := dict "fullnameOverride" $base | dict "Values" -}}
{{- $values := merge $diff . -}}
{{- template "common.fullname" $values -}}
{{- end -}}

{/*
Create a default fully qualified oauth2-proxy name.
*/}}
{{- define "portal.oauth2-proxy.fullname" -}}
{{- $base := ( printf "%s-%s" .Release.Name "oauth2-proxy" ) -}}
{{- $diff := dict "fullnameOverride" $base | dict "Values" -}}
{{- $values := merge $diff . -}}
{{- template "common.fullname" $values -}}
{{- end -}}

{/*
Schema
*/}}
{{- define "portal.schema" -}}
{{- if .Values.ingress.tls.enabled -}}
{{- printf "https" -}}
{{- else -}}
{{- printf "http" -}}
{{- end -}}
{{- end -}}


{/*
External auth auth-url endpoint
*/}}
{{- define "portal.auth-url" -}}
{{- printf "%s://$host/oauth2/auth" (include "portal.schema" . ) -}}
{{- end -}}

{/*
External auth auth-signin endpoint
*/}}
{{- define "portal.auth-signin" -}}
{{- printf "%s://$host/oauth2/start" (include "portal.schema" . ) -}}
{{- end -}}

{/*
External auth auth-request-redirect endpoint
*/}}
{{- define "portal.auth-request-redirect" -}}
{{- printf "%s://$host/" (include "portal.schema" . ) -}}
{{- end -}}

{{- /*
portal.proxy.labels.standard prints the standard Helm labels for proxy.

The standard labels are frequently used in metadata.
*/ -}}
{{- define "portal.proxy.labels.standard" -}}
app: {{ template "portal.proxy.name" . }}
chart: {{ template "common.chartref" . }}
heritage: {{ .Release.Service | quote }}
release: {{ .Release.Name | quote }}
{{- end -}}

