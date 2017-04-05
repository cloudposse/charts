{ "items": [
{{- if and .Values.rules.specifiedInValues .Values.rules.value }}
  {
    "key": "{{ .Release.Namespace }}/prometheus-{{ .Release.Name }}-rules",
    "checksum": "mock_hash"
  }
{{- end }}
]}