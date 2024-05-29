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

{{/* Only add env block if not used by above .Values.env */}}
{{- if not $root.Values.env}}
env:
{{- end }}
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

{{/*
The affinity
*/}}
{{- define "monochart.affinity" -}}
{{- $root := first . }}
{{- $specific := last . }}
{{- $config := mergeOverwrite $root.Values.affinity (get $specific "affinity") -}}
{{- if $config }}
affinity:
{{- if or $config.podAntiAffinity (eq $config.affinityRule "ShouldBeOnDifferentNode") }}
  podAntiAffinity:
    preferredDuringSchedulingIgnoredDuringExecution:
{{- if $config.podAntiAffinity }}
{{- if $config.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution }}
{{- with $config.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution }}
{{ toYaml . | indent 6 }}
{{- end }}
{{- end }}
{{- end }}
{{- if eq $config.affinityRule "ShouldBeOnDifferentNode" }}
{{- include "monochart.affinityRule.ShouldBeOnDifferentNode" $root | nindent 6 }}
{{- end }}
{{- end }}
{{- if $config.podAffinity }}
  podAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
{{- with $config.podAffinity.requiredDuringSchedulingIgnoredDuringExecution }}
{{ toYaml . | indent 6 }}
{{- end }}
{{- end }}
{{- if $config.nodeAffinity }}
  nodeAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
{{- if $config.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution }}
{{- with $config.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution }}
{{ toYaml . | indent 6 }}
{{- end }}
{{- end }}
    preferredDuringSchedulingIgnoredDuringExecution:
{{- if $config.nodeAffinity.preferredDuringSchedulingIgnoredDuringExecution }}
{{- with $config.nodeAffinity.preferredDuringSchedulingIgnoredDuringExecution }}
{{ toYaml . | indent 6 }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}

{{- end -}}

{{/*
The nodeSelector
*/}}
{{- define "monochart.nodeSelector" -}}
{{- $root := first . }}
{{- $specific := last . }}
{{- $config := mergeOverwrite $root.Values.nodeSelector (get $specific "nodeSelector") -}}
{{- if $config }}
{{- with $config }}
nodeSelector:
{{ toYaml . | indent 2 }}
{{- end }}
{{- end }}
{{- end -}}

{{/*
The tolerations
*/}}
{{- define "monochart.tolerations" -}}
{{- $root := first . }}
{{- $specific := last . }}
{{- $config := default $root.Values.tolerations (get $specific "tolerations") -}}
{{- if $config }}
{{- with $config }}
tolerations:
{{ toYaml . | indent 2 }}
{{- end }}
{{- end }}
{{- end -}}
