SHELL = /bin/bash
export BUILD_HARNESS_PATH ?= $(shell until [ -d "build-harness" ] || [ "`pwd`" == '/' ]; do cd ..; done; pwd)/build-harness
-include $(BUILD_HARNESS_PATH)/Makefile

helm\:all: package index

.PHONY : fix-perms
## Fix filesystem permissions
helm\:fix-perms:
	@find . -type f -name '*.yaml' -exec chmod 644 {} \;
	@find . -type f -name '*.txt' -exec chmod 644 {} \;
	@find . -type f -name '*.tpl' -exec chmod 644 {} \;
	@find . -type f -name '*.md' -exec chmod 644 {} \;
	@find . -type f -name '*.tgz' -exec chmod 644 {} \;

.PHONY : info
## Show information about each repo
helm\:info:
	@make -C stable $@
	@make -C incubator $@

.PHONY : package
## Generate packages of all charts
helm\:package:
	@make -C stable $@
	@make -C incubator $@

.PHONY : index
## Index all packages
helm\:index:
	@make -C stable $@
	@make -C incubator $@

.PHONY : clean
## Clean up 
helm\:clean:
	@make -C stable $@
	@make -C incubator $@

.PHONY : lint
## Lint
helm\:lint:
	@make -C stable/library $@
	@make -C incubator/library $@

.PHONY : init
## Init build-harness
init:
	@curl --retry 5 --retry-delay 1 https://raw.githubusercontent.com/cloudposse/build-harness/feature-support-helm/bin/install.sh | bash /dev/stdin build-harness feature-support-helm

.PHONY : clean
## Clean build-harness
clean:
	@rm -rf $(BUILD_HARNESS_PATH)

