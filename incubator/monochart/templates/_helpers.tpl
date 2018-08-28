{{- define "monochart.env" -}}

envFrom:
{{- if .Values.configMap.enabled }}
- configMapRef:
    name: {{ include "common.fullname" . }}
{{- end }}
{{- if .Values.secret.enabled }}
- secretRef:
    name: {{ include "common.fullname" . }}
{{- end }}

env:
{{- range $name, $value := .Values.env }}
{{- if not (empty $value) }}
{{ include "common.envvar.value" $name $value }}
{{- end }}
{{- end }}

{{- if .Values.configMap.enabled }}
{{- $configMapName := include "common.fullname" . }}
{{- range $name, $value := .Values.configMap.env }}
{{- if not ( empty $value) }}
{{ include "common.envvar.configmap" $name $configMapName $name  }}
{{- end }}
{{- end }}
{{- end }}

{{- if .Values.secret.enabled }}
{{- $secretName := include "common.fullname" . }}
{{- range $name, $value := .Values.secret.env }}
{{- if not ( empty $value) }}
{{ include "common.envvar.secret" $name $secretName $name  }}
{{- end }}
{{- end }}
{{- end }}

{{- end -}}
