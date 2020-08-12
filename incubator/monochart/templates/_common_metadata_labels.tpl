{{- /*
From obsolete Kubernetes Incubator Common chart
https://github.com/helm/charts/blob/master/incubator/common/

common.labelize takes a dict or map and generates labels.

Values will be quoted. Keys will not.

Example output:

  first: "Matt"
  last: "Butcher"

*/ -}}
{{- define "common.labelize" -}}
    {{- range $k, $v := . }}
        {{ $k }}: {{ $v | quote }}
    {{- end -}}
{{- end -}}

{{- /*
common.chartref prints a chart name and version.

It does minimal escaping for use in Kubernetes labels.

Example output:

  zookeeper-1.2.3
  wordpress-3.2.1_20170219

*/ -}}
{{- define "common.chartref" -}}
    {{- replace "+" "_" .Chart.Version | printf "%s-%s" .Chart.Name -}}
{{- end -}}

{{- /*
common.labels.standard prints the standard Helm labels.

The standard labels are frequently used in metadata.
*/ -}}
{{- define "common.labels.standard" -}}
app: {{ template "common.name" . }}
chart: {{ template "common.chartref" . }}
heritage: {{ .Release.Service | quote }}
release: {{ .Release.Name | quote }}
{{- end -}}
