SHELL := /bin/bash

# Binaries

GO ?= go
GOLANGCI_LINT ?= golangci-lint
TEE ?= tee
GREP ?= grep
FIND ?= find

# Variables

GO_TEST_DIRECTORIES ?= tests
GOLANGCI_LINT_CONFIG ?= .golangci.yaml
DISABLE_MAKE_CHECK_LINT ?= true

# Functions

# Checks for Go files in the GO_TEST_DIRECTORIES. If they exist, runs the default configuration for golangci-lint
# https://golangci-lint.run/usage/quick-start/
define go_lint
	$(FIND) $(1)/ -name '*.go' | $(GREP) -q '\.go' || exit 0; $(GOLANGCI_LINT) run -c $(GOLANGCI_LINT_CONFIG) -v ./$(1)/...;

endef

# Check for Go files. If they exist, run tests.
define go_test
	$(FIND) $(1)/ -name '*.go' | $(GREP) -q '\.go' || exit 0; $(GO) test -v ./$(1)/...;

endef

# Tasks

.PHONY: go/lint
go/lint :
	$(call go_lint)

.PHONY: go/test
go/test :
	$(foreach test_dir,$(GO_TEST_DIRECTORIES),$(call go_test,$(test_dir)))

# This is a special declaration
# Whenever check is defined, it must be defined with a ::
# _all_ check targets that are found will be run
# https://www.gnu.org/software/make/manual/html_node/Double_002dColon.html
# "check" is a GNU Make pattern that runs tests on configured software
.PHONY: check
check::
ifeq ($(DISABLE_MAKE_CHECK_LINT),false)
	$(MAKE) go/lint
else
	$(info "make go/lint has been disabled!")
endif
	$(MAKE) go/test