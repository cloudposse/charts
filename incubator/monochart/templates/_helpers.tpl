{{- define "monochart.env.fullname" -}}
{{- $root := index . 0 -}}
{{- $postfix := index . 1 -}}
{{- printf "%s-%s-%s" (include "common.fullname" $root) "env" $postfix -}}
{{- end -}}

{{- define "monochart.files.fullname" -}}
{{- $root := index . 0 -}}
{{- $postfix := index . 1 -}}
{{- printf "%s-%s-%s" (include "common.fullname" $root) "files" $postfix -}}
{{- end -}}

{{- define "monochart.env" -}}
{{- if and .Values.configMaps .Values.secrets }}
envFrom:
{{- range $name, $config := .Values.configMaps -}}
{{- if $config.enabled }}
- configMapRef:
    name: {{ include "monochart.env.fullname" (list . $name) }}
{{- end }}
{{- end }}
{{- range $name, $secret := .Values.secrets -}}
{{- if .Values.secret.enabled }}
- secretRef:
    name: {{ include "monochart.env.fullname" (list . $name) }}
{{- end }}
{{- end }}
{{- end }}
{{- with .Values.env }}
env:
{{- range $name, $value := . }}
  - name: {{ $name }}
    value: {{ default "" $value | quote }}
{{- end }}
{{- end }}
{{- end -}}
