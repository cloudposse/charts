{{/* vim: set filetype=mustache: */}}

{{/*
Fullname of configMap/secret that contains environment vaiables
*/}}
{{- define "monochart.env.fullname" -}}
{{- $root := index . 0 -}}
{{- $postfix := index . 1 -}}
{{- printf "%s-%s-%s" (include "common.fullname" $root) "env" $postfix -}}
{{- end -}}

{{/*
Fullname of configMap/secret that contains files
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
{{- if $root.Values.configMaps | or $root.Values.secrets | or $root.Values.envFrom }}
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
{{- if $root.Values.envFrom }}
{{- with $root.Values.envFrom }}
{{- range $name := .configMaps }}
- configMapRef:
    name: {{ $name }}
{{- end }}
{{- range $name := .secrets }}
- secretRef:
    name: {{ $name }}
{{- end }}
{{- end }}
{{- end -}}
{{- end }}
{{- with $root.Values.env }}
env:
{{- range $name, $value := . }}
  - name: {{ $name }}
    value: {{ default "" $value | quote }}
{{- end }}
{{- end }}
{{/*
https://kubernetes.io/docs/tasks/inject-data-application/environment-variable-expose-pod-information/#use-pod-fields-as-values-for-environment-variables
*/}}
{{- with $root.Values.envFromFieldRefFieldPath }}
env:
{{- range $name, $value := . }}
  - name: {{ $name }}
    valueFrom:
      fieldRef:
        fieldPath: {{ $value }}
{{- end }}
{{- end }}
{{/*
https://kubernetes.io/docs/concepts/configuration/secret/#using-secrets-as-environment-variables
*/}}
{{- with $root.Values.envFromSecretKeyRef }}
{{- range $data := . }}
  - name: {{ $data.name }}
    valueFrom:
      secretKeyRef:
        name: {{ $data.secret }}
        key: {{ $data.key }}
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
The pod anti-affinity rule to prefer not to be scheduled onto a node if that node is already running a pod with same app
*/}}
{{- define "monochart.affinityRule.ShouldBeOnDifferentNode" -}}
- weight: 100
  podAffinityTerm:
    labelSelector:
      matchExpressions:
      - key: app
        operator: In
        values:
        - {{ include "common.name" . }}
      - key: release
        operator: In
        values:
        - {{ .Release.Name | quote }}
    topologyKey: "kubernetes.io/hostname"
{{- end -}}

