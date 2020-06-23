# Helm 3
HELM=helm
STAGE=$(notdir $(CURDIR))
PACKAGES_DIR=../packages/$(STAGE)

all: deps $(wildcard */)

deps:
	$(HELM) repo add kubernetes-incubator https://kubernetes-charts-incubator.storage.googleapis.com/
	$(HELM) repo add cloudposse-incubator https://charts.cloudposse.com/incubator/
	$(HELM) repo add kuberentes-stable https://kubernetes-charts.storage.googleapis.com
	$(HELM) repo add kubernetes-stable-alt http://storage.googleapis.com/kubernetes-charts
	mkdir -p $(PACKAGES_DIR)

%/: Makefile
	@echo "# Building package for $(@D)"
	@$(HELM) dependency build --debug $@
	@$(HELM) package --debug $@
	mv $(@D)*.tgz $(PACKAGES_DIR)

clean:
	rm -f *.tgz */requirements.lock
	rm -rf */tmpcharts/

