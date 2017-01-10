ifneq ($(TRAVIS_PULL_REQUEST_BRANCH),)
  BRANCH=pr-$(TRAVIS_PULL_REQUEST_BRANCH)
else ifneq ($(TRAVIS_BRANCH),)
  BRANCH=$(TRAVIS_BRANCH)
else ifneq ($(TRAVIS_TAG),)
  BRANCH=$(TRAVIS_TAG)
else
  BRANCH=$(shell git rev-parse --abbrev-ref HEAD)
endif

ifeq ($(BRANCH),master)
export REPO_URL ?= https://charts.cloudposse.com
else
export REPO_URL ?= https://charts.dev.cloudposse.com/$(BRANCH)
endif

all: package index

.PHONY : info
## Show information about each repo
info:
	@make -C stable $@
	@make -C incubator $@
	@make -C distro $@

.PHONY : package
## Generate packages of all charts
package: 
	@make -C stable $@
	@make -C incubator $@
	@make -C distro $@

.PHONY : index
## Index all packages
index:
	@make -C stable $@
	@make -C incubator $@
	@make -C distro $@

.PHONY : clean
## Clean up 
clean:
	@make -C stable $@
	@make -C incubator $@
	@make -C distro $@

.PHONY : lint
## Lint
lint:
	@make -C stable/library $@
	@make -C incubator/library $@
	@make -C distro $@

