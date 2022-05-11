REPO_MANIFESTS_URL ?= https://github.com/nexient-llc/module-manifests.git
REPO_BRANCH ?= main
REPO_MANIFEST ?= components.xml

# Set to true in a pipeline context
IS_PIPELINE ?= false

JOB_NAME ?= job
JOB_EMAIL ?= job@job.job


.PHONY: configure
configure:
	repo init \
		-u "$(REPO_MANIFESTS_URL)" \
		-b "$(REPO_BRANCH)" \
		-m "$(REPO_MANIFEST)"
	repo sync

ifeq ($(IS_PIPELINE),true)
.PHONY: git-config
git-config:
	$(call config,Bearer $(GIT_TOKEN))

define config
	@set -ex; \
	git config --global http.extraheader "AUTHORIZATION: $(1)"; \
	git config --global http.https://gerrit.googlesource.com/git-repo/.extraheader ''; \
	git config --global http.version HTTP/1.1; \
	git config --global user.name "$(JOB_NAME)"; \
	git config --global user.email "$(JOB_EMAIL)"; \
	git config --global color.ui false
endef

configure: git-config
endif

# The first line finds and removes all the directories pulled in by repo
# The second line finds and removes all the broken symlinks from removing things
# https://stackoverflow.com/questions/42828021/removing-files-with-rm-using-find-and-xargs
.PHONY: clean
clean:
	repo list | awk '{ print $1; }' | cut -d '/' -f1 | uniq | xargs rm -rf
	find . -type l ! -exec test -e {} \; -print | xargs rm -rf
