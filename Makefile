COMPONENTS_DIR ?= components
MODULE_DIR ?= $(COMPONENTS_DIR)/module

-include $(MODULE_DIR)/tasks/**/Makefile

TFLINT_CONFIG ?= $(MODULE_DIR)/.tflint.hcl
CONFTEST_POLICY_DIRECTORIES += $(MODULE_DIR)/policy

FIND ?= find
GREP ?= grep
OPA ?= opa

.PHONY: default
default:
	@echo "Using Make components at $(shell basename $(MODULE_DIR))"

.PHONY: rego/test
rego/test:
	$(FIND) $(CONFTEST_POLICY_DIRECTORIES) -name '*.rego' | $(GREP) -q '\.rego' || exit 0; $(OPA) test --verbose $(CONFTEST_POLICY_DIRECTORIES)

# This is a special declaration
# Whenever check is defined, it must be defined with a ::
# _all_ check targets that are found will be run
# https://www.gnu.org/software/make/manual/html_node/Double_002dColon.html
# "check" is a GNU Make pattern that runs tests on configured software
.PHONY: check
check::
	$(MAKE) rego/test
