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
{{ include "common.envvar.value" (list $name $value) | indent 2 }}
{{- end }}
{{- end }}

{{- if .Values.configMap.enabled }}
{{- $configMapName := include "common.fullname" . }}
{{- range $name, $value := .Values.configMap.env }}
{{- if not ( empty $value) }}
{{ include "common.envvar.configmap" (list $name $configMapName $name) | indent 2  }}
{{- end }}
{{- end }}
{{- end }}

{{- if .Values.secret.enabled }}
{{- $secretName := include "common.fullname" . }}
{{- range $name, $value := .Values.secret.env }}
{{- if not ( empty $value) }}
{{ include "common.envvar.secret" (list $name $secretName $name) | indent 2  }}
{{- end }}
{{- end }}
{{- end }}

{{- end -}}
