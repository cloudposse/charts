kube-prometheus: prometheus-operator kube-prometheus-*.tgz

prometheus-operator: prometheus-operator-*.tgz

kube-prometheus-*.tgz:
	cp prometheus-operator-*.tgz kube-prometheus/charts
	helm package kube-prometheus

prometheus-operator-*.tgz:
	helm package prometheus-operator

clean:
	rm -f kube-prometheus/charts/*
	rm -f *.tgz
