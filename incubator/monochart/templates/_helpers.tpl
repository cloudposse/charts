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


{{/*
Volumes template block for deployable resources
*/}}
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

{{/*
VolumeMounts template block for deployable resources
*/}}
{{- define "monochart.files.volumeMounts" -}}
{{- range $name, $config := .Values.configMaps -}}
{{- if $config.enabled }}
- mountPath: {{ default (printf "/%s" $name) $config.mountPath }}
  name: config-{{ $name }}-files
{{- end }}
{{- end -}}
{{- range $name, $secret := .Values.secrets -}}
{{- if $secret.enabled }}
- mountPath: {{ default (printf "/%s" $name) $secret.mountPath }}
  name: secret-{{ $name }}-files
  readOnly: true
{{- end }}
{{- end -}}
{{- end -}}


{{/*
Containers
*/}}
{{- define "monochart.containers" -}}
{{- $containers := first . }}
{{- $values := last . }}
{{- range $name, $container := $containers }}
{{- if $container.enabled }}
{{- if eq $name "default" }}
{{- $container := $values }}
{{- end }}
- name: {{ $name }}
  image: {{ $container.image.repository }}:{{ $container.image.tag }}
  imagePullPolicy: {{ $container.image.pullPolicy }}
{{ include "monochart.env" $values | indent 2 }}
{{if $container.args }}args: {{ $container.args }}{{- end }}
  volumeMounts:
  - mountPath: /data
    name: storage
{{ include "monochart.files.volumeMounts" $values | indent 2 }}
{{- with $container.probes }}
{{ toYaml . | indent 2 }}
{{- end }}
{{- with $container.resources }}
  resources:
{{ toYaml . | indent 2 }}
{{- end }}
  imagePullSecrets:
{{- if $values.dockercfg.enabled }}
  - name: {{ include "common.fullname" . }}
{{- end }}
{{- with $container.image.pullSecrets }}
{{- range . }}
  - name: {{ . }}
{{- end }}
{{- end }}

{{- end }}
{{- end }}
{{- end -}}
