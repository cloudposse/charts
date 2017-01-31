kube-prometheus: kube-prometheus-*.tgz

kube-prometheus-*.tgz:
	helm dep update kube-prometheus
	helm lint kube-prometheus
	helm package kube-prometheus

prometheus-operator: prometheus-operator-*.tgz

prometheus-operator-*.tgz:
	helm dep update prometheus-operator
	helm lint prometheus-operator
	helm package prometheus-operator

clean:
	rm -f *.tgz
