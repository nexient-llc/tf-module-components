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
DISABLE_MAKE_CHECK_LINT ?= false

# Linting
ifeq ($(DISABLE_MAKE_CHECK_LINT),false)
.PHONY: go/lint
go/lint:
	$(foreach test_dir,$(GO_TEST_DIRECTORIES),$(call go_lint,$(test_dir)))

# Checks for Go files in the GO_TEST_DIRECTORIES. If they exist, runs the default configuration for golangci-lint
# https://golangci-lint.run/usage/quick-start/
define go_lint
	$(FIND) $(1)/ -name '*.go' | $(GREP) -q '\.go' || exit 0; $(GOLANGCI_LINT) run -c $(GOLANGCI_LINT_CONFIG) -v ./$(1)/...;

endef

check:: go/lint
endif

# Testing
.PHONY: go/test
go/test:
	$(foreach test_dir,$(GO_TEST_DIRECTORIES),$(call go_test,$(test_dir)))

# Check for Go files. If they exist, run tests.
define go_test
	$(FIND) $(1)/ -name '*.go' | $(GREP) -q '\.go' || exit 0; $(GO) test -v ./$(1)/...;

endef

# Check is dependent upon go/lint (optionally) and go/test
.PHONY: check
check:: go/test
	
