SHELL := /bin/bash

# Binaries

GO ?= go
TEE ?= tee
GREP ?= grep

# Variables

GO_TEST_DIRECTORIES ?= tests/
DISABLE_MAKE_CHECK_LINT ?= false

# Functions

# Runs go vet and ignores errors when there are no Go files
define go_lint
	OUTPUT=$$(set -o pipefail; $(GO) vet ./... 2>&1 | $(TEE) /dev/stdout); [ "$$?" = "0" ] || { echo $$OUTPUT | $(GREP) -q 'go mod init' || exit 1; }

endef

# Ensures the tests/ dir exists before running tests
define go_test
	[ -d "$(1)" ] && $(GO) test -v ./$(1) || exit 0;

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
