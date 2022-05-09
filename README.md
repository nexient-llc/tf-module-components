# tf-module-components

## Important Patterns in this Repo

### `make check`

`check` is [one of many "standard" targets](https://www.gnu.org/software/make/manual/make.html#Standard-Targets).

> Perform self-tests (if any). The user must build the program before running the tests, but need not install the program; you should write the self-tests so that they work when the program is built but not installed.

`check` should be used to collect all of the targets in a Makefile that tell us whether or not things work. Common dependencies are linting and testing targets. `check` is a common pattern that should be present in any Makefile; it's just a convenience target to have a single point of entry for pipelines. The target should collect _all_ of these items in a specific Makefile.

`check` is defined as [a double-colon rule](https://www.gnu.org/software/make/manual/html_node/Double_002dColon.html). This allows us to define `check` multiple times across multiple Makefiles. Each definition can be thought of appending new commands (note that the execution order of the different `check`s should **not** matter; if it does you need to reevaluate). They will all be run. In this module, you can see that each `Makefile` has its own `check` target that collects linting and testing for items in that specific Makefile.

> Whenever you want to consume make files that aren't under the default naming convention (e.g. Makefile), use `makefile -f path/to/file`.

### Graceful "Does not Exist" Target Failures

This repo is meant to be consumed by other things. Attempting to run its targets in isolation means it has nothing to consume. All default and `check` targets need to be able to run successfully even without items to consume.
* Each Makefile is run with `--just-print`, eg `make -f path/to/file --just-print`. If this fails, `make check` will fail. This is to mitigate any effects from accidentally running a Makefile.
* In order to test this repo, we need to run its `make check`. Because it's [a double-colon target](https://www.gnu.org/software/make/manual/html_node/Double_002dColon.html), it will run all other `check`s. Any repo consuming this one will as well. Therefore a dry `make check` should not lead to failures because something doesn't exist. For example, the `go/*` targets cehck for necessary Go files and fail silently if those files do not exist.

### All Code is Tested

This is a library module that provides common functionality to repos. It is hard to test things like shared targets. However, we need to have some confidence in this code. Everything in this repo is tested via `make check` in a way that makes some sense. The Rego is validated via Open Policy Agent. We ensure the Makefiles don't have dangerous default behavior and that any found `check`s fail gracefully if necessary items do not exist. As more tools are added, keep this in mind.
