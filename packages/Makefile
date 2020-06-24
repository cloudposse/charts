HELM ?= helm
CURL ?= curl
HELM_CHART_REPO_URL ?= https://charts.cloudposse.com

%/index.yaml: $(wildcard */*.tgz)
	@$(CURL) --fail -s -q $(HELM_CHART_REPO_URL)/$@ -o /tmp/index.yaml; \
	if [ $$? -eq 0 ]; then \
		echo "## Merging index with $(HELM_CHART_REPO_URL)/$(dir $@)"; \
		$(HELM) repo index $(dir $@) --merge /tmp/index.yaml --url $(HELM_CHART_REPO_URL)/$(dir $@) --debug; \
	else \
		echo "## Generating new index for $(HELM_CHART_REPO_URL)/$(dir $@)"; \
		$(HELM) repo index $(dir $@) --url $(HELM_CHART_REPO_URL)/$(dir $@) --debug; \
	fi;

incubator/: incubator/index.yaml

all: incubator/index.yaml

