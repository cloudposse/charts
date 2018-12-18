{{/* vim: set filetype=mustache: */}}

{{/*
Fullname of configMap/secret that contains environment vaiables.
*/}}
{{- define "monochart.env.fullname" -}}
{{- $root := index . 0 -}}
{{- $postfix := index . 1 -}}
{{- printf "%s-%s-%s" (include "common.fullname" $root) "env" $postfix -}}
{{- end -}}

{{/*
Fullname of configMap/secret that contains files.
*/}}
{{- define "monochart.files.fullname" -}}
{{- $root := index . 0 -}}
{{- $postfix := index . 1 -}}
{{- printf "%s-%s-%s" (include "common.fullname" $root) "files" $postfix -}}
{{- end -}}

{{/*
Environment template block for deployable resources
*/}}
{{- define "monochart.env" -}}
{{- $root := . -}}
{{- if or .Values.configMaps $root.Values.secrets }}
envFrom:
{{- range $name, $config := $root.Values.configMaps -}}
{{- if $config.enabled }}
{{- if not ( empty $config.env ) }}
- configMapRef:
    name: {{ include "monochart.env.fullname" (list $root $name) }}
{{- end }}
{{- end }}
{{- end }}
{{- range $name, $secret := $root.Values.secrets -}}
{{- if $secret.enabled }}
{{- if not ( empty $secret.env ) }}
- secretRef:
    name: {{ include "monochart.env.fullname" (list $root $name) }}
{{- end }}
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


{{/*
Volumes template block for deployable resources
*/}}
{{- define "monochart.files.volumes" -}}
{{- $root := . -}}
{{- range $name, $config := $root.Values.configMaps -}}
{{- if $config.enabled }}
{{- if not ( empty $config.files ) }}
- name: config-{{ $name }}-files
  configMap:
    name: {{ include "monochart.files.fullname" (list $root $name) }}
{{- end }}
{{- end }}
{{- end -}}
{{- range $name, $secret := $root.Values.secrets -}}
{{- if $secret.enabled }}
{{- if not ( empty $secret.files ) }}
- name: secret-{{ $name }}-files
  secret:
    secretName: {{ include "monochart.files.fullname" (list $root $name) }}
{{- end }}
{{- end }}
{{- end -}}
{{- end -}}

{{/*
VolumeMounts template block for deployable resources
*/}}
{{- define "monochart.files.volumeMounts" -}}
{{- range $name, $config := .Values.configMaps -}}
{{- if $config.enabled }}
{{- if not ( empty $config.files ) }}
- mountPath: {{ default (printf "/%s" $name) $config.mountPath }}
  name: config-{{ $name }}-files
{{- end }}
{{- end }}
{{- end -}}
{{- range $name, $secret := .Values.secrets -}}
{{- if $secret.enabled }}
{{- if not ( empty $secret.files ) }}
- mountPath: {{ default (printf "/%s" $name) $secret.mountPath }}
  name: secret-{{ $name }}-files
  readOnly: true
{{- end }}
{{- end }}
{{- end -}}
{{- end -}}


{{/*
Image template block
*/}}
{{- define "monochart.pod.image" -}}
{{- $root := index . 0 -}}
{{- $override := index . 1 -}}
image: {{ default (required "image.repository is required!" $root.Values.image.repository) $override.image.repository  }}:{{ default (required "image.tag is required!" $root.Values.image.tag) $override.image.tag }}
imagePullPolicy: {{ default $root.Values.image.pullPolicy $override.image.pullPolicy }}
{{- end -}}


{{/*
Template block for Pod's commands/args
*/}}
{{- define "monochart.pod.cmd" -}}
{{- $root := index . 0 -}}
{{- $propName := index . 1 -}}
{{- $arr := index . 2 -}}
{{- with $arr }}
{{ $propName }}:
{{- range $arg := . }}
  - |-
{{- tpl $arg $root | indent 4 -}}
{{- end }}
{{- end }}
{{- end -}}
