TRAVIS_BRANCH ?= $(shell git rev-parse --abbrev-ref HEAD)

ifeq ($(TRAVIS_BRANCH),master)
export REPO_URL ?= https://charts.cloudposse.com
else
export REPO_URL ?= https://charts.dev.cloudposse.com/$(TRAVIS_BRANCH)
endif

all: package index

.PHONY : info
## Show information about each repo
info:
	@make -C stable $@
	@make -C incubator $@

.PHONY : package
## Generate packages of all charts
package: 
	@make -C stable $@
	@make -C incubator $@

.PHONY : index
## Index all packages
index:
	@make -C stable $@
	@make -C incubator $@

.PHONY : clean
## Clean up 
clean:
	@make -C stable $@
	@make -C incubator $@

.PHONY : lint
## Lint
lint:
	@make -C stable/library $@
	@make -C incubator/library $@
