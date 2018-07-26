
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
scheme
*/}}
{{- define "portal.scheme" -}}
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
{{- printf "%s://$host/oauth2/auth" (include "portal.scheme" . ) -}}
{{- end -}}

{/*
External auth auth-signin endpoint
*/}}
{{- define "portal.auth-signin" -}}
{{- printf "%s://$host/oauth2/start?rd=$request_uri" (include "portal.scheme" . ) -}}
{{- end -}}

{/*
External auth auth-request-redirect endpoint
*/}}
{{- define "portal.auth-request-redirect" -}}
{{- printf "%s://$host/" (include "portal.scheme" . ) -}}
{{- end -}}
