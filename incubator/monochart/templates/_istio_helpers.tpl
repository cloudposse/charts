{{/* vim: set filetype=mustache: */}}

{{/*
The pod anti-affinity rule to prefer not to be scheduled onto a node if that node is already running a pod with same app
*/}}
{{- define "monochart.istio.virtualService.http" -}}
{{ $root := first . }}
{{ $item := last . }}
{{- with $item }}
name: {{ .name | quote }}

{{- if not ( empty .match ) }}
  match:
{{- range $match := .match -}}
  - {{ toYaml $match }}
{{- end }}
{{- end }}

{{- if not ( empty .route ) }}
  route:
{{- range $route := .route -}}
  - {{ include "monochart.istio.virtualService.http.route" ( list $root $route ) }}
{{- end }}
{{- end }}

{{- if not ( empty .redirect ) }}
{{- with .redirect }}
  redirect:
{{ toYaml . | indent 4 }}
{{- end }}
{{- end }}

{{- if not ( empty .rewrite ) }}
{{- with .rewrite }}
  rewrite:
{{ toYaml . | indent 4 }}
{{- end }}
{{- end }}

{{- if not ( empty .timeout ) }}
{{- with .timeout }}
  timeout:
{{ toYaml . | indent 4 }}
{{- end }}
{{- end }}

{{- if not ( empty .retries ) }}
{{- with .retries }}
  retries:
{{ toYaml . | indent 4 }}
{{- end }}
{{- end }}

{{- if not ( empty .fault ) }}
{{- with .fault }}
  fault:
{{ toYaml . | indent 4 }}
{{- end }}
{{- end }}

{{- if not ( empty .mirror ) }}
{{- with .mirror }}
  mirror:
{{ toYaml . | indent 4 }}
{{- end }}
{{- end }}

{{- if not ( empty .corsPolicy ) }}
{{- with .corsPolicy }}
  corsPolicy:
{{ toYaml . | indent 4 }}
{{- end }}
{{- end }}

{{- if not ( empty .headers ) }}
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
{{- if not ( empty .headers ) }}
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
{{- if not ( empty .subset ) }}
subset: {{ .subset | quote }}
{{- end }}
{{- if not ( empty .port ) }}
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
number: {{ index $root.Values.service.ports $port | .external }}
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
{{- if not ( empty .match ) }}
match:
{{- range $match := .match -}}
- {{ toYaml $match }}
{{- end }}
{{- end }}

{{- if not ( empty .route ) }}
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
