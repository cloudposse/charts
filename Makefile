export REPO_URL ?= https://charts.cloudposse.com

all: package index

.PHONY : info
## Show information about each repo
info:
	@make -C stable $@
	@make -C incubator $@
	@make -C test $@

.PHONY : package
## Generate packages of all charts
package: 
	@make -C stable $@
	@make -C incubator $@
	@make -C test $@

.PHONY : index
## Index all packages
index:
	@make -C stable $@
	@make -C incubator $@
	@make -C test $@

