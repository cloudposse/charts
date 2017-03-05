all: alertmanager-%.tgz kube-prometheus-%.tgz prometheus-%.%.%.tgz prometheus-operator-%.tgz

CHART_REPO_BUCKET = "charts.opsgoodness.com"

alertmanager-%.tgz:
	helm lint alertmanager
	helm dep update alertmanager
	helm package alertmanager

kube-prometheus-%.tgz:
	helm lint kube-prometheus
	helm dep update kube-prometheus
	helm package kube-prometheus

prometheus-%.%.%.tgz:
	helm lint prometheus
	helm dep update prometheus
	helm package prometheus

prometheus-operator-%.tgz:
	helm lint prometheus-operator
	helm dep update prometheus-operator
	helm package prometheus-operator

ship: alertmanager-%.tgz kube-prometheus-%.tgz prometheus-%.%.%.tgz prometheus-operator-%.tgz
	gsutil cp "gs://$(CHART_REPO_BUCKET)/index.yaml" .
	helm repo index . --url "http://$(CHART_REPO_BUCKET)" --merge index.yaml
	gsutil -h Cache-Control:private cp -a public-read \
		"$(CHART)*.tgz" "gs://$(CHART_REPO_BUCKET)"
	gsutil -h Cache-Control:private cp -a public-read \
		index.yaml "gs://$(CHART_REPO_BUCKET)"

clean:
	rm -f *.tgz
