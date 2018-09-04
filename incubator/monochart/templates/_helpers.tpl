{{- define "monochart.env.fullname" -}}
{{- printf "%s-%s" (include "common.fullname" .) "env" -}}
{{- end -}}

{{- define "monochart.files.fullname" -}}
{{- printf "%s-%s" (include "common.fullname" .) "files" -}}
{{- end -}}

{{- define "monochart.env" -}}
{{- if and .Values.configMap.enabled .Values.secret.enabled }}
envFrom:
{{- if .Values.configMap.enabled }}
- configMapRef:
    name: {{ include "monochart.env.fullname" . }}
{{- end }}
{{- if .Values.secret.enabled }}
- secretRef:
    name: {{ include "monochart.env.fullname" . }}
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
