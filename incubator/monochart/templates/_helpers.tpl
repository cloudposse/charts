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
{{- $root := . -}}
{{- if and .Values.configMaps $root.Values.secrets }}
envFrom:
{{- range $name, $config := $root.Values.configMaps -}}
{{- if $config.enabled }}
- configMapRef:
    name: {{ include "monochart.env.fullname" (list $root $name) }}
{{- end }}
{{- end }}
{{- range $name, $secret := $root.Values.secrets -}}
{{- if $secret.enabled }}
- secretRef:
    name: {{ include "monochart.env.fullname" (list $root $name) }}
{{- end }}
{{- end }}
{{- end }}
{{- with $root.Values.env }}
env:
{{- range $name, $value := . }}
  - name: {{ $name }}
    value: {{ default "" $value | quote }}
{{- end }}
{{- end }}
{{- end -}}

{{- define "monochart.files.volumes" -}}
{{- $root := . -}}
{{- range $name, $config := $root.Values.configMaps -}}
{{- if $config.enabled }}
- name: config-{{ $name }}-files
  configMap:
    name: {{ include "monochart.files.fullname" (list $root $name) }}
{{- end }}
{{- end -}}
{{- range $name, $secret := $root.Values.secrets -}}
{{- if $secret.enabled }}
- name: secret-{{ $name }}-files
  secret:
    secretName: {{ include "monochart.files.fullname" (list $root $name) }}
{{- end }}
{{- end -}}
{{- end -}}

{{- define "monochart.files.volumeMounts" -}}
{{- range $name, $config := .Values.configMaps -}}
{{- if $config.enabled }}
- mountPath: {{ $config.mountPath }}
  name: config-{{ $name }}-files
{{- end }}
{{- end -}}
{{- range $name, $secret := .Values.secrets -}}
{{- if $secret.enabled }}
- mountPath: {{ $secret.mountPath }}
  name: secret-{{ $name }}-files
  readOnly: true
{{- end }}
{{- end -}}
{{- end -}}
