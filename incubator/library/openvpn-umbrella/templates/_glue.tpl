{{/*
Create a dashboard service name.
We truncate at 24 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "openvpn_proxy_upstream" -}}
{{- printf "%s-%s" .Release.Name "letsencrypt-umbrella" | trunc 24 | trimSuffix "-" -}}.{{- .Release.Namespace -}}:80
{{- end -}}

{{/*
Create a dashboard service name.
We truncate at 24 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "openvpn_share_port" -}}
-e "port-share {{ printf "%s-%s" .Release.Name "letsencrypt-umbrella" | trunc 24 | trimSuffix "-" -}}.{{- .Release.Namespace }} 443" \
{{- end -}}

{{/*
Create a dashboard service name.
We truncate at 24 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "letsencrypt_umbrella_target_endpoint" -}}
{{- printf "%s-%s" .Release.Name "openvpn-dashboard" | trunc 24 | trimSuffix "-" -}}.{{- .Release.Namespace -}}:80
{{- end -}}

{{/*
Create a dashboard service name.
*/}}
{{- define "letsencrypt_secret" -}}
{{- .Release.Name -}}-letsencrypt
{{- end -}}