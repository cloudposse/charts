all: monochart

# Test incubator repo
monochart: HELM_CHART_REPO_URL ?= https://charts.cloudposse.com
monochart: HELM_CHART_VERSION ?= $(shell yq r ../incubator/monochart/Chart.yaml version)
monochart:
	@echo "Testing for monochart $(HELM_CHART_VERSION)..."
	  helm repo add test-incubator $(HELM_CHART_REPO_URL)/incubator
	  helm repo update
	  helm search repo test-incubator/monochart -l -o table --version $(HELM_CHART_VERSION) | grep -qv "No results found"
	  helm pull test-incubator/monochart --version $(HELM_CHART_VERSION)
	@echo "Success!"

