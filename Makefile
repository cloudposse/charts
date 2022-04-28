-include $(shell curl -sSL -o .build-harness "https://cloudposse.tools/build-harness"; echo .build-harness)
build:
	docker run -v $(CURDIR)/incubator:/build-harness/incubator -v $(CURDIR)/packages:/build-harness/packages \
		-e HELM_CHART_REPO_URL=https://charts.cloudposse.com/incubator \
		cloudposse/build-harness:0.36.0 -C incubator all

index:
	docker run -v $(CURDIR)/incubator:/build-harness/incubator -v $(CURDIR)/packages:/build-harness/packages \
		-e HELM_CHART_REPO_URL=https://charts.cloudposse.com/incubator \
		cloudposse/build-harness:0.36.0 -C packages all

all: build index
	@exit 0
