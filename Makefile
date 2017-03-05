all: alertmanager-%.tgz prometheus-%.%.%.tgz prometheus-operator-%.tgz

CHART_REPO_BUCKET = "charts.opsgoodness.com"

alertmanager-%.tgz:
	helm dep update alertmanager
	helm lint alertmanager
	helm package alertmanager

# kube-prometheus: kube-prometheus-*.tgz
#
# kube-prometheus-*.tgz:
#   helm dep update kube-prometheus
#   helm lint kube-prometheus
#   helm package kube-prometheus

prometheus-%.%.%.tgz:
	helm dep update prometheus
	helm lint prometheus
	helm package prometheus

prometheus-operator-%.tgz:
	helm dep update prometheus-operator
	helm lint prometheus-operator
	helm package prometheus-operator

ship: alertmanager-%.tgz prometheus-%.%.%.tgz prometheus-operator-%.tgz
	gsutil cp "gs://$(CHART_REPO_BUCKET)/index.yaml" .
	helm repo index . --url "http://$(CHART_REPO_BUCKET)" --merge index.yaml
	gsutil -h Cache-Control:private cp -a public-read \
		"$(CHART)*.tgz" "gs://$(CHART_REPO_BUCKET)"
	gsutil -h Cache-Control:private cp -a public-read \
		index.yaml "gs://$(CHART_REPO_BUCKET)"

clean:
	rm -f *.tgz
