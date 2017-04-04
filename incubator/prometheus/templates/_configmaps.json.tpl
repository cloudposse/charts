{ "items": [
{{- if and .Values.rules.specifiedInValues .Values.rules.value }}
  {
    "key": "{{ .Release.Namespace }}/prometheus-{{ .Release.Name }}-rules",
    "checksum": "33bbd11f3d6ecfa14af3d46c46e91de4906fe86d2429f34ba6ee74082f9d6414"
  }
{{- end }}
]}