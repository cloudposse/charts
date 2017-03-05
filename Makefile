.phony: alertmanager prometheus prometheus-operator

all: alertmanager prometheus prometheus-operator

alertmanager: alertmanager-*.*.*.tgz

alertmanager-*.*.*.tgz:
	helm dep update alertmanager
	helm lint alertmanager
	helm package alertmanager

# kube-prometheus: kube-prometheus-*.tgz
#
# kube-prometheus-*.tgz:
#   helm dep update kube-prometheus
#   helm lint kube-prometheus
#   helm package kube-prometheus

prometheus: prometheus-*.*.*.tgz

prometheus-*.*.*.tgz:
	helm dep update prometheus
	helm lint prometheus
	helm package prometheus

prometheus-operator: prometheus-operator-*.tgz

prometheus-operator-*.tgz:
	helm dep update prometheus-operator
	helm lint prometheus-operator
	helm package prometheus-operator

clean:
	rm -f *.tgz
