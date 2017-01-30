kube-prometheus: kube-prometheus-*.tgz
	helm lint kube-prometheus
	helm package kube-prometheus

prometheus-operator: prometheus-operator-*.tgz
	helm lint prometheus-operator
	helm package prometheus-operator

clean:
	rm -f *.tgz
