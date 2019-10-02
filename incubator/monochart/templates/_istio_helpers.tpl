{{/* vim: set filetype=mustache: */}}

{{/*
The pod anti-affinity rule to prefer not to be scheduled onto a node if that node is already running a pod with same app
*/}}
{{- define "monochart.istio.virtualService.http" -}}
{{ $root := first . }}
{{ $item := last . }}
{{- with $item }}
name: {{ .name | quote }}

{{- if gt ( len .match ) 0 }}
  match:
{{- range $match := .match -}}
  - {{ toYaml $match }}
{{- end }}
{{- end }}

{{- if gt ( len .route ) 0 }}
  route:
{{- range $route := .route -}}
  - {{ include "monochart.istio.virtualService.http.route" ( list $root $route ) }}
{{- end }}
{{- end }}

{{- if gt ( len .redirect ) 0 }}
{{- with .redirect }}
  redirect:
{{ toYaml . | indent 4 }}
{{- end }}
{{- end }}

{{- if gt ( len .rewrite ) 0 }}
{{- with .rewrite }}
  rewrite:
{{ toYaml . | indent 4 }}
{{- end }}
{{- end }}

{{- if gt ( len .timeout ) 0 }}
{{- with .timeout }}
  timeout:
{{ toYaml . | indent 4 }}
{{- end }}
{{- end }}

{{- if gt ( len .retries ) 0 }}
{{- with .retries }}
  retries:
{{ toYaml . | indent 4 }}
{{- end }}
{{- end }}

{{- if gt ( len .fault ) 0 }}
{{- with .fault }}
  fault:
{{ toYaml . | indent 4 }}
{{- end }}
{{- end }}

{{- if gt ( len .mirror ) 0 }}
{{- with .mirror }}
  mirror:
{{ toYaml . | indent 4 }}
{{- end }}
{{- end }}

{{- if gt ( len .corsPolicy ) 0 }}
{{- with .corsPolicy }}
  corsPolicy:
{{ toYaml . | indent 4 }}
{{- end }}
{{- end }}

{{- if gt ( len .headers ) 0 }}
{{- with .headers }}
  headers:
{{ toYaml . | indent 4 }}
{{- end }}
{{- end }}

{{- end }}

{{- end -}}

{{- define "monochart.istio.virtualService.http.route" -}}
{{ include "monochart.istio.virtualService.route" . }}
{{ $root := first . }}
{{ $item := last . }}
{{- with $item }}
{{- if gt ( len .headers ) 0 }}
{{- with .headers }}
headers:
{{ toYaml . | indent 2 }}
{{- end }}
{{- end }}
{{- end }}

{{- end -}}

{{- define "monochart.istio.virtualService.destination" -}}
{{ $root := first . }}
{{ $item := last . }}
{{- with $item }}
host: {{ .host }}
{{- if gt ( len .subset ) 0 }}
subset: {{ .subset | quote }}
{{- end }}
{{- if gt ( len .port ) 0 }}
port:
{{ include "monochart.istio.virtualService.destination.port" ( list $root .port ) | indent 2 }}
{{- end }}
{{- end }}
{{- end -}}

{{- define "monochart.istio.virtualService.destination.port" -}}
{{ $root := first . }}
{{ $item := last . }}
{{- with $item }}
{{- if kindIs "string" . }}
{{- $port := . }}
number: {{ $root.Values.service.ports.$port.external }}
{{- else }}
{{ toYaml . }}
{{- end }}
{{- end }}
{{- end -}}

{{- define "monochart.istio.virtualService.route" -}}
{{ $root := first . }}
{{ $item := last . }}
{{- with $item }}
destination:
{{ include "monochart.istio.virtualService.destination" ( list $root .destination ) | indent 2 }}
weight: {{ .weight }}
{{- end }}
{{- end -}}

{{- define "monochart.istio.virtualService.Xroute" -}}
{{ $root := first . }}
{{ $item := last . }}
{{- with $item }}
{{- if gt ( len .match ) 0 }}
match:
{{- range $match := .match -}}
- {{ toYaml $match }}
{{- end }}
{{- end }}

{{- if gt ( len .route ) 0 }}
route:
{{- range $route := .route -}}
- {{ include "monochart.istio.virtualService.route" ( list $root $route ) }}
{{- end }}
{{- end }}
{{- end }}
{{- end -}}

{{- define "monochart.istio.virtualService.tls" -}}
{{ include "monochart.istio.virtualService.Xroute" . }}
{{- end -}}

{{- define "monochart.istio.virtualService.tcp" -}}
{{ include "monochart.istio.virtualService.Xroute" . }}
{{- end -}}
