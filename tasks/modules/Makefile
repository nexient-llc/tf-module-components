SHELL := /bin/bash

# Binaries

TERRAFORM ?= terraform
RM ?= rm -rf
CONFTEST ?= conftest
TFLINT ?= tflint
FIND ?= find

# Variables

ALL_TF_MODULES = $(shell $(call list_terraform_modules))
CONFTEST_POLICY_DIRECTORIES ?= $(MODULE_DIR)/policy
TFLINT_CONFIG ?= .tflint.hcl

# Functions

define check_terraform_fmt
	echo && echo "Checking format ...";
	$(TERRAFORM) fmt -recursive -check;

endef

define clean_terraform_module
	$(RM) $(1)/.terraform* $(1)/terraform.*;

endef

define conftest_terraform_module
	$(CONFTEST) test $(1)/terraform.tfplan.json $(foreach dir,$(CONFTEST_POLICY_DIRECTORIES),$(shell echo "-p $(dir) "));

endef

define init_terraform_module
	echo && echo "Initializing $(1) ...";
	$(TERRAFORM) -chdir=$(1) init -backend=false -input=false;

endef

define list_terraform_modules
	$(FIND) . -path "*/.terraform" -prune -o -name "main.tf" -not -path '*pipeline*' -not -path '*examples*' -exec dirname {} \;;

endef

define plan_terraform_module
	echo && echo "Planning $(1) ...";
	$(TERRAFORM) -chdir=$(1) plan -input=false -out=terraform.tfplan;
	echo && echo "Creating JSON plan output for $(1) ...";
	cd $(1) && $(TERRAFORM) show -json ./terraform.tfplan > ./terraform.tfplan.json;

endef

define tflint_terraform_module
	echo && echo "Linting $(1) ...";
	(cd $(1) && $(TFLINT) --loglevel=info -c $(TFLINT_CONFIG)) || exit 1;

endef

define validate_terraform_module
	echo && echo "Validating $(1) ...";
	$(TERRAFORM) -chdir=$(1) validate || exit 1;

endef

# Tasks

.PHONY: tfmodule/all
tfmodule/all: tfmodule/lint tfmodule/test

.PHONY: tfmodule/clean
tfmodule/clean :
	@$(foreach module,$(ALL_TF_MODULES),$(call clean_terraform_module,$(module)))

.PHONY: tfmodule/fmt
tfmodule/fmt :
	$(TERRAFORM) fmt -recursive;

.PHONY: tfmodule/init
tfmodule/init :
	@$(foreach module,$(ALL_TF_MODULES),$(call init_terraform_module,$(module)))

.PHONY: tfmodule/lint
tfmodule/lint : tfmodule/init
	@$(call check_terraform_fmt)
	@$(foreach module,$(ALL_TF_MODULES),$(call tflint_terraform_module,$(module)))
	@$(foreach module,$(ALL_TF_MODULES),$(call validate_terraform_module,$(module)))

.PHONY: tfmodule/list
tfmodule/list :
	@echo $(ALL_TF_MODULES) | tr ' ' '\n' | sort

.PHONY: tfmodule/plan
tfmodule/plan : tfmodule/init
	@$(foreach module,$(ALL_TF_MODULES),$(call plan_terraform_module,$(module)))

.PHONY: tfmodule/test
tfmodule/test : tfmodule/plan
	@$(foreach module,$(ALL_TF_MODULES),$(call conftest_terraform_module,$(module)))

.PHONY: check
check::
	$(MAKE) tfmodule/lint
	$(MAKE) tfmodule/test
