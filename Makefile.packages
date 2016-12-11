#
# Default makefile to manipulate package repo
#

export REPO_URL := $(REPO_URL)/packages

info:
	@echo "REPO_URL: $(REPO_URL)"

index:
	@helm repo index . --url $(REPO_URL)

real-clean: clean
	rm -f *.tgz

clean:
	rm -f index.yaml
