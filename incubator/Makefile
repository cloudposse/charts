# Helm 3
HELM=helm
STAGE=$(notdir $(CURDIR))
PACKAGES_DIR=../packages/$(STAGE)

CHARTS = $(wildcard */)

all: deps $(wildcard */)

deps:
	$(HELM) repo add kubernetes-incubator https://charts.helm.sh/incubator
	$(HELM) repo add cloudposse-incubator https://charts.cloudposse.com/incubator/
	$(HELM) repo add kuberentes-stable 	https://charts.helm.sh/stable
	$(HELM) repo add kubernetes-stable-alt 	https://charts.helm.sh/stable
	mkdir -p $(PACKAGES_DIR)

clean:
	rm -f *.tgz */requirements.lock
	rm -rf */tmpcharts/

.PHONY : $(CHARTS)
$(CHARTS): CHART ?= $(@D)
$(CHARTS): VERSION ?= $(shell yq eval .version $(CHART)/Chart.yaml)
$(CHARTS): PACKAGE ?= $(CHART)-$(VERSION).tgz
$(CHARTS):
	@echo "# Building package for $(CHART) ($(PACKAGE))"
	@$(HELM) dependency build --debug $@
	@$(HELM) package --debug $@
	mv -f $(PACKAGE) $(PACKAGES_DIR)


