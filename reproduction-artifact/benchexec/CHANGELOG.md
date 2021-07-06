<!--
This file is part of BenchExec, a framework for reliable benchmarking:
https://github.com/sosy-lab/benchexec

SPDX-FileCopyrightText: 2007-2020 Dirk Beyer <https://www.sosy-lab.org>

SPDX-License-Identifier: Apache-2.0
-->

# BenchExec Changelog

## BenchExec 3.8

This release works only on Python 3.6 and newer!

- Add possibility to have a `close()` method to tool-info modules.
- The `test_tool_info` utility now has a `--debug` argument
  that will show the debug log, e.g., from the tool-info module.
- Fix bug in detection of CPU throttling during benchmarking,
  for which we warn if we detect it.
  This did not work for cases with core numbers longer than one digit.
- Properly escape the suggested command line for running table-generator
  that is shown by benchexec before it terminates.
- Allow specifying path to libseccomp via environment variable `LIBSECCOMP`.
  This is useful for environments like NixOS.
- Fix handling of empty result files in table-generator,
  the generated HTML tables will work again.
- Fix handling of empty run results when filtering rows in HTML tables.
- Make filters for status and textual columns in HTML tables work
  if filter string contains a colon.
- When entering a filter in the HTML tables' filter row,
  do not loose focus on the input field when applying the filter,
  such that users can continue typing.
- Fix invalid values shown in score-based quantile plot
  if some runs of a table do not have a score value.
  Now a run set is only shown in a score-based quantile plot
  if all values have scores (otherwise the plot would be misleading).
- Text selection now works as expected while an overlay window is open
  in the HTML tables (only text in the overlay will be selected).

## BenchExec 3.7

This is expected to be the last BenchExec release that supports Python 3.5,
newer releases will require Python 3.6 or newer.
Please [cf. issue #717](https://github.com/sosy-lab/benchexec/issues/717)
for our plan on dropping support for further Python versions.

We would like to note that Linux kernel 5.11
brings a major improvement for BenchExec users not on Ubuntu:
Now it should be possible to use the overlayfs feature as a regular user,
no need to pass `--read-only-dir /` and similar parameters.
We updated our [installation instructions](https://github.com/sosy-lab/benchexec/blob/master/doc/INSTALL.md)
accordingly and also clarified that BenchExec requires x86 or ARM machines
and recommend Linux kernel 4.14 or newer due to reduced cgroups overhead.

Changes in this release:

- In HTML tables, the following settings are now stored in the hash part of the URL:
  - Column sorting
  - Page size of the table, i.e., how many rows are shown
  - Filters for task names that are defined by entering text
    into the left-most input field of the filter row of the table.
    Previously this would only work for task-name filters defined in the filter sidebar.
  This means that using the back/forward navigation of the browser
  will change these settings and that they can be present in shared links.
- Fix a few cases of printing of statistics information in HTML tables.
  This affects corner cases like the number of visible decimal digits for `0`
  and trailing zeroes for the standard deviation in the tooltip.
- When a user requests rounding to a certain number of decimal digits,
  the filtering functionality of the HTML tables will now use the raw values,
  not the rounded values.
  This is consistent with the behavior when rounding is not explicitly requested
  and BenchExec applies the default rounding rules.
- Fix harmless stack trace printed at end of `benchexec` execution
  in cases like of early termination, e.g., if the tool could not be found.
- Some improvements to tool-info modules.
- Several updates of JS libraries, but this should not bring user-visible changes.

## BenchExec 3.6

- One tool-info module improved.

## BenchExec 3.5

- One tool-info module improved.

## BenchExec 3.4

- BenchExec is now available in a PPA for easy installation on Ubuntu.
  Just run the following commands

      sudo add-apt-repository ppa:sosy-lab/benchmarking
      sudo apt install benchexec

- Column filters are now reflected in the URL of HTML tables.
  This makes it possible to open a table, configure some filters,
  and share a link with others that will apply these filters on load.
  Furthermore, using the back and forward buttons of the browser
  will now also update the applied filters.
- Add parameter `--initial-table-state` to `table-generator`,
  which allows to define the default state of HTML tables
  (e.g., filters, opened tab, etc.).
- Category-specific statistics are shown more often again on first table tab.
  Since BenchExec 3.0 these were removed in some cases where we cannot compute
  them, but this accidentally removed them from more than the desired cases.
- Improved rounding in table-generator.
- SV-COMP scoring schema updated according to rules of SV-COMP'21.
- Many tool-info modules updated to use the new API from BenchExec 3.3
  and improvements for SV-COMP'21 and Test-Comp'21.
- Improved warnings in certain cases where a benchmark definition
  does not make sense (e.g., `<exclude>` tags that do not match anything).
- HTML tables now show a proper error message if the browser is not supported
  and also a loading message.
- Several smaller bug fixes like avoiding crashes in corner cases.

## BenchExec 3.3

- New API for tool-info modules (needed by `benchexec` for getting information
  about the benchmarked tool). The new API is defined by class
  [`benchexec.tools.template.BaseTool2`](https://github.com/sosy-lab/benchexec/blob/master/benchexec/tools/template.py)
  and is similar to the old API, but more convenient to use and provides more
  useful information to the tool-info module.
  The old API is still supported
  and will be removed no sooner than in BenchExec 4.0. We also provide a
  [migration guide](https://github.com/sosy-lab/benchexec/blob/master/doc/tool-integration.md#migrating-tool-info-modules-to-new-api).
- A new parameter `--tool-directory` for `benchexec` allows to specify
  the installation directory of the benchmarked tool easily
  without having to modify `PATH` or change into the tool's directory.
  Note that this only works if the respective tool-info module
  makes use of the new `BaseTool2` API.
- New version 2.0 of the
  [task-definition format](https://github.com/sosy-lab/benchexec/blob/master/doc/benchexec.md#task-definition-files)
  for `benchexec`.
  This format allows to specify arbitrary additional information in a key
  named `options` and `benchexec` will pass everything in this key
  to the tool-info module, but note that this only works
  if the respective tool-info module makes use of the new `BaseTool2` API.
  This is useful to add domain-specific information about tasks, for example
  in the [SV-Benchmarks](https://github.com/sosy-lab/sv-benchmarks#task-definitions)
  repository it is used to declare the program language.
  BenchExec also still supports version 1.0 of the format.

- `table-generator` is now defined to work on Windows
  and we test this in continuous integration.
  Previously, it probably was working on Windows most of the time
  but we did not systematically test this.
- Fix a crash in `benchexec` for task with property
  but without task-definition file.

## BenchExec 3.2

- The HTML tables produced by `table-generator` now provide a score-based
  quantile plot in addition to the regular quantile plot if scores are used.
  If available, it is shown by default on the tab for quantile plots.
  Score-based quantile plots are for example used by SV-COMP to visualize results.
- Better axis labels in scatter plot of HTML tables.
- More auxiliary lines available in scatter plot of HTML tables.
- New tool-info module added.

Bug fixes:

- Fix crash in `benchexec` if a non-SV-COMP property was used.
- Fix for empty property files being treated as SV-COMP properties.
- Fix unnecessarily large I/O for text file with results of `benchexec`
  during benchmarking. The `.results.txt` file is now written incrementally.
- Fix incorrect handling of `<withoutfile>` tasks if the tool-info module
  declared a non-standard working directory.
- Small fix for the new filter overlay in the HTML tables
  when the first run set has no filter.

## BenchExec 3.1

- Fix our `benchexec.check_cgroups` installation check,
  which showed invalid warnings since BenchExec 2.7.
- Improve handling of inaccessible mountpoints in containers.
  This should make it possible to use nested containers on most systems
  using the default arguments (e.g., no need for `--hidden-dir /sys`).
- Improved row filters of HTML tables (thanks to @DennisSimon).
  In addition to filtering via drop-down fields in the table header,
  it is now also possible to define filters on a separate overlay,
  which can be opened from all tabs via a button in the top-right corner
  (e.g., also while looking at plots).
  The filters for status and category in the filter overlay are more flexible
  because several values can be selected for status and category.
  This allows to define filters like
  `category = "correct" AND (status = "false" OR status = "false(unreach-call)")`.
  Furthermore, the filter overlay allows to filter the parts of the task id
  (left-most column) individually and makes it easier to define filters
  with numeric ranges.
- Redesigned UI for changing the plot settings of quantile and scatter plots
  in the HTML tables (thanks to @lachnerm).
- Hiding columns in HTML tables is now reflected in the URL.
  This makes it possible to create links to tables that hide columns.

## BenchExec 3.0

This release contains only one new feature compared to BenchExec 2.7:

- Tables produced by `table-generator` now show the expected verdict of each task,
  if it is known and it is not the same for all rows.

However, there are several deprecated features removed
and other backwards-incompatible changes
to make BenchExec more consistent and user-friendly:

- Support for Python 2.7 and 3.4 is removed,
  the minimal Python version is now 3.5 for all components of BenchExec.
  We plan to remove support for Python 3.5
  after Ubuntu 16.04 goes out of support in 2021.
- If a tool-info module returns `UNKNOWN` for a run result,
  BenchExec will no longer overwrite that if it thinks the tool terminated
  abnormally. It will continue to do so if `ERROR` is returned.
- Result values named `cpuenergy-pkg[0-9]+` are renamed to `cpuenergy-pkg[0-9]+-package`
  because these are not a sum of all the other CPU-energy measurements.
- Names of result files produced by `benchexec` now contain timestamps
  with seconds in order to avoid problems when starting `benchexec`
  in quick succession.
- Support for generating the old-style static HTML tables
  (with `table-generator --static-table`) is removed.
  Only the modern tables that are available since BenchExec 2.3
  and CSV tables can be generated.
- More metadata are stored in result files of `benchexec`,
  so `table-generator` no longer needs access to the task-definition files,
  and changes to the expected verdict that are made after benchmarking
  will not be reflected in tables.
- The Python library Tempita is no longer a dependency of BenchExec.
- We do not create and distribute `.egg` packages for BenchExec releases anymore,
  only the more modern `.whl` packages,
  as well as Debian/Ubuntu packages and Tar archives.

Furthermore, BenchExec no longer contains hard-coded knowledge about any specific property,
all properties are treated in the same way.
(The only exception is that score computation is enabled for SV-COMP properties.)
This simplification implies several more changes:

- For checking expected verdicts and computing scores it is now required that
  task-definition files are used.
  Expected verdicts encoded in the task name are no longer supported.
- Tool-info modules need to return results `true` or `false`,
  the results `sat` and `unsat` are no longer supported
  (these were allowed only for the property `SATISFIABLE`).
- There is no special handling for composite properties like SV-COMP's property
  for memory safety anymore. Previously this property would be represented as
  a collection of its subproperties, now it is treated as one property.
  Task-definition files can still contain a violated subproperty,
  and `benchexec` will continue to use this information for checking the tool result,
  but this does not depend on which property is used.
- Score computation is fixed for tables where property files have uncommon names.
  The name of property files is now no longer relevant (as it should have been).
  Because of this, `table-generator` needs to have access to
  the property files that were used during benchmarking.


## BenchExec 2.7

- The supplied file `benchexec-cgroup.service` for cgroup configuration
  on systems with systemd now works with systemd 240 or newer
  (e.g., on Ubuntu 20.04).
  This also affects the Debian package of BenchExec.
- Error messages about failed cgroup access were improved.
- Buttons below plots in the HTML table do not need to be clicked twice.
- Directly opening the quantile tab of HTML tables via the URL works now.
- First line of logs shown in overlay of HTML tables is selectable again.

## BenchExec 2.6

This release brings several improvements for the new kind of HTML tables
produced by `table-generator`, in particular:

- Add hash routing, i.e., the possibility to navigate to certain parts
  of the application directly by adding a suffix to the URL.
  For example, opening `...table.html#/table` will directly open the table.
  While navigating through the application, the URL automatically adjusts.
  This also means that it is possible to use the "Back" button of the browser
  for going back to previously opened tabs or for closing an overlay window.
  Thanks @DennisSimon for this!
- Make references to files in task-definition files clickable.
  When clicking on a cell in the first column of table,
  it shows the task-definition file in an overlay.
  Now the file's YAML content is parsed and links to input files are added.
  Thanks @lachnerm for this!
- Fix filtering of negative values in half-open intervals.
- More tooltips and hover effects on table headers to improve usability.
- The table tab now appropriately adjusts if the browser window is resized.
- Fix legend of quantile plot if some columns are empty/missing,
  and show disabled columns in gray.
- Fix scatter plot if not all data points have valid values.
- Fix layout of column-selection dialog in case not all columns are present
  for all run sets.
- Fix scrolling behavior of close button of overlay windows.
- In case the property is the same for all tasks of a table,
  it was not shown so far in the table. Now we show it on the summary tab.
- Improve position of scroll bars across all tabs.

There are also a few changes in other parts of BenchExec:

- Fix mount problems in container mode if mount points with unusual characters
  (like `:`) or bind mounts over files exist.
  The latter is for example relevant when nesting containers
  (inside another BenchExec or Docker container).
- Several new tool-info modules and small improvements to existing ones.
- `runexec` now creates parent directories of output files if necessary.
- `table-generator` now works if environment variable `LANG` is missing.
- `table-generator` should now work on Windows.
- It is possible to turn off colored output on stdout by setting the
  environment variable `NO_COLOR` (cf. https://no-color.org/).
- In the `contrib` folder, we now provide a script for generating
  task-definition files in YAML format for old-style tasks.


## BenchExec 2.5.1

This release does not contain any changes to BenchExec itself,
just for a script in the `contrib` directory.

## BenchExec 2.5

This release contains only a small improvement of one tool-info module.

## BenchExec 2.4

(not released)

## BenchExec 2.3

- A complete rewrite of the HTML tables produced by `table-generator`.
  The tables are now based on [React](https://reactjs.org/), load much faster,
  and provide features like pagination, sorting, and more intuitive filters.
  More information can be found in [PR #477](https://github.com/sosy-lab/benchexec/pull/477).
  Thanks @bschor for this!
  Note that the tables are not usable without JavaScript anymore.
  The old kind of HTML tables can still be produced with the command-line flag
  `--static-table`, but this is deprecated and will be removed in BenchExec 3.0
  in January 2020 (cf. [#479](https://github.com/sosy-lab/benchexec/issues/479)).
- Recursively clean up cgroups after a run.
  This enables nesting `runexec` in itself,
  but only if `--full-access-dir /sys/fs/cgroup` is passed to the outer `runexec`,
  which means that the processes in the outer container have full access
  to the cgroup hierarchy and could use this to circumvent resource limits.
- `benchexec` filters the tasks to execute depending on the expected verdict,
  if `<propertyfile expectedverdict="...">` in used the benchmark definition.
- BenchExec now stores a timestamp for the start time of each run,
  and timestamps for start and end of reach run set.
- `benchexec` will store arbitrary user-defined text as benchmark description
  together with the results if specified with `benchexec --description-file ...`.
- Support for execution on Python 3.8.
- Fix crash in `runexec` if the tool's stdout/stderr contain invalid UTF-8.
- Fix hanging `benchexec` in container mode if tool cannot be executed
  (e.g., if executable is missing).
- New tool-info modules and updates for SV-COMP'20 and Test-Comp'20.


## BenchExec 2.2

This release fixes two security issues, all users are encouraged to update:

- Since BenchExec 2.1, the setup of the container for the tool-info module
  (which was added in BenchExec 1.20) could silently fail, for example
  if user namespaces are disabled on the system. In this case the tool-info
  module would be executed outside of the container.
  Run execution was not affected.
- The kernel offers a keyring feature for storage of keys related to features
  like Kerberos and ecryptfs. Before Linux 5.2, there existed one keyring per
  user, and BenchExec did not prevent access from the tool inside the container
  to the kernel keyring of the user who started BenchExec.
  Now such accesses are forbidden (on all kernel versions) using
  [seccomp](http://man7.org/linux/man-pages/man2/seccomp.2.html)
  if [libseccomp2](https://github.com/seccomp/libseccomp) is installed,
  which should the case on any standard distribution.
  Note that seccomp filters do have a slight performance impact
  and could prevent some binaries on exotic architectures from working.
  In such a case please file a [bug report](https://github.com/sosy-lab/benchexec/issues/new).


## BenchExec 2.1

`benchexec` can now partition the Level 3 cache of the CPU for parallel runs
and measure cache usage and memory bandwidth,
at least on some Intel CPUs and if the [pqos](https://github.com/intel/intel-cmt-cat/tree/master/pqos)
and [pqos_wrapper](https://gitlab.com/sosy-lab/software/pqos-wrapper) are installed.
More information is in the [documentation](https://gitlab.com/sosy-lab/software/pqos-wrapper/wikis/home).

Furthermore, some error messages for systems without container support were improved.


## BenchExec 2.0

This release does not add new features compared to BenchExec 1.22,
but removes several deprecated features and brings several other backwards-incompatible changes
to make BenchExec more consistent and user-friendly:

- Support for Python 3.2 and 3.3 is removed, the minimal Python version is now 3.4.
  Additionally, `runexec`/`RunExecutor` continue to support Python 2.7
  [until end of 2019](https://github.com/sosy-lab/benchexec/issues/438).
- Support for running benchmarks as a different user with `sudo` is removed
  (parameters `--user`/`--users`).
  Use container mode as better method for isolating runs.
- [Container mode](doc/container.md) is enabled by default.
  It can be disabled with `--no-container`,
  but this decreases reliability of benchmarking.
- If the `cpuacct` cgroup is not available,
  CPU-time measurements and limits are not supported.
- Either container mode or the `freezer` cgroup are required
  to ensure protection against fork bombs.
- [Niceness](http://man7.org/linux/man-pages/man2/nice.2.html)
  of benchmarked process is not changed, previously it was increased by 5.
- Changes to input of `benchexec`:
  - The memory limit given to `benchexec` requires an explicitly specified unit.
  - Support for `<test>` tags, `<sourcefiles>` tags,
    and variables named `${sourcefile_*}` removed from benchmark definitions.
    Use `<rundefinition>`, `<tasks>`, and `${inputfile_*}` instead.
  - Variables named `${taskdef_*}` are defined only if task-definition files are used,
    and variables named `${inputfile_*}` only otherwise.
- Changes to `table-generator`:
  - A column named `memUsage` is automatically renamed to `memory`.
  - A column named `memory` is automatically converted to Megabytes.
  Both conversions are only applied if no `<column>` tags are used.
- Changes to [run-result data](doc/run-results.md):
  - In case of aborted or failed runs, no dummy results (e.g., `cputime` of 0s)
    are present.
  - The memory results of `benchexec` are named `memory`, not `memUsage`.
  - Memory results have the unit `B` explicitly specified.
    Furthermore, units are present in all attributes of the result XML files
    where they were still missing.
  - Result item `exitcode` is removed, only `RunExecutor.execute_run()` still returns it,
    but as an object instance instead of an `int`.
    Use `returnvalue` and `exitsignal` instead.
- Module `benchexec.test_tool_wrapper` is removed, use `benchexec.test_tool_info` instead.
- BenchExec (both `benchexec` and `runexec`) terminates itself cleanly after aborting all runs
  if it receives one of the signals `SIGTERM`, `SIGINT` (Ctrl+C), or `SIGQUIT`.

Additionally, this release adds a fix for the container
that is used since BenchExec 1.20 for the tool-info module.
In this container, the environment variable `HOME` did not point to `/home/benchexec`
as expected but to the user's real home directory.
This broke tools like Ultimate if the `/home` was configured to be hidden or read-only.

Furthermore, we declare the following features deprecated
and plan on removing them for [BenchExec 3.0](https://github.com/sosy-lab/benchexec/milestone/8),
which is expected to be released in January 2020:

- Support for Python 2.7 and 3.4 (cf. [#438](https://github.com/sosy-lab/benchexec/issues/438))
- Support for checking correctness of run results and computing scores
  if task-definition files are *not* used (cf. [#439](https://github.com/sosy-lab/benchexec/issues/439))

Please respond in the respective issue if one of these deprecations
is a problem for you.


## BenchExec 1.22

- More robust handling of Ctrl+C in `benchexec`.
  For example, output files are now always fully written, whereas previously
  pressing Ctrl+C at the wrong time could result in truncated files.
  A side effect of this is that if you call
  `benchexec.benchexec.BenchExec().start()` in own Python code,
  you must now add a signal handler for `SIGINT`.
  The same was already true for users of `RunExecutor`, this is now documented.
- Fix Ctrl+C for `benchexec` in container mode.
  In BenchExec 1.21, one would need to press Ctrl+C twice to stop `benchexec`.
- Fix unreliable container mode on Python 3.7.
- Some robustness improvements and fixes of rare deadlocks.
- Decreased overhead of `benchexec` while runs are executing.


## BenchExec 1.21

This release contains only a few bug fixes:

- Forwarding signals to the benchmarked process (and thus, stopping runs via Ctrl+C),
  was broken on Python 2.
- If the freezer cgroup was available but mounted in a separate hierarchy,
  it was not used reliably as protection against fork bombs when killing processes.
- Since BenchExec 1.19, an exception would occur if a non-existing command
  was started in container mode.
- Since BenchExec 1.19, copying output files from a container would occur
  while subprocesses are still running and would be counted towards the
  walltime limit. This is fixed, although subprocesses will still be running
  if the freezer cgroup is not available (cf. #433).


## BenchExec 1.20

- If `benchexec --container` is used, all code that is part of the tool-info
  module (as well as all processes started by it) are now run in a separate
  container with the same layout and restrictions as the run container.
  Note, however, that it is not the same container, so any modifications
  made by the tool-info module to files on disk are *not* visible in the runs!
  The `test_tool_info` utility also has gained a parameter `--container`
  for testing how a tool-info module behaves in a container.
- Nested containers are now supported.
  Due to a change to the internal implementation of the container mode,
  commands like the following succeed now:
  `containerexec -- containerexec --hidden-dir /sys -- /bin/bash`.
  (Some parts of `/sys` need to be excluded because of kernel limitations.)
  Note that nesting `runexec` or `benchexec` is still not supported,
  because nested cgroups are not implemented,
  so any cgroup-related features (resource limitations and measurements)
  are missing. But nesting `containerexec` and `runexec --container`
  (or vice-versa) now works.
- `/etc/hostname` in container now also shows the container's host name
  that exists since BenchExec 1.19.
- Change how CPUs with several NUMA nodes per CPU are handled:
  BenchExec will now treat each NUMA node like a separate CPU package
  and avoid creating runs that span several NUMA nodes. Thanks @alohamora!


## BenchExec 1.19

- In container mode, all temp directories are now on a `tmpfs` "RAM disk".
  This affects everything written to directories in the hidden or overlay modes.
  Files written there are now included in the memory measurements and the memory limit!
  The advantage is that performance should be more deterministic,
  especially if several runs use much I/O in parallel.
  This feature can be disabled with `--no-tmpfs`.
- `/dev/shm` and `/run/shm` are now available inside the container
  and provide a `tmpfs` instance (even with `--no-tmpfs`)
  as required by some tools for shared memory.
- Container mode now recommends [LXCFS](https://github.com/lxc/lxcfs)
  and automatically uses it if available for a better container isolation
  (e.g., uptime measures container uptime, not host uptime).
  On Debian/Ubuntu, just use `sudo apt install lxcfs`.
- Several small bug fixes and other improvements of isolation for container mode
  (e.g., host name in container is no longer the real host name).
- Add `benchexec --no-hyperthreading`, which restricts core assignments
  to a single virtual core per physical CPU core
  (all other sibling cores will stay unused). Thanks @alohamora!


## BenchExec 1.18

- Add result `done` that tools can output if the standard results `true`/`false`/`unknown`
  are not applicable (for example because no property was checked),
  and the run completed successfully.
- In container mode, `--keep-system-config` is no longer necessary if overlayfs
  is not used for `/etc`, and thus it is is no longer automatically implied in such cases.
- Benchmark definitions support a new attribute `displayName` with a human-readable name
  that will be shown in tables.
- A new variable `${taskdef_name}` can now be used in places where variable substitution is supported.
- Table-generator supports `%` as unit for numerical values.
- Some improvements for score handling outside of SV-COMP (i.e., if scores are not calculated by BenchExec).
- New tool-info modules for Test-Comp'19
- Several small bug fixes and improvements


## BenchExec 1.17

- Tasks can now be defined in a YAML-based format,
  cf. [the documentation](https://github.com/sosy-lab/benchexec/blob/master/doc/benchexec.md#task-definition-files)
  This supports tasks with several input files,
  and allows providing metadata such as expected verdicts
  in a structured format instead of encoded in the file name.
  The format will be extended to handle more information in the future.
- The wall-time limit can now be specified separately from the CPU-time limit
  for `benchexec` as command-line parameter or in the benchmark definition.
- Support for SV-COMP'19 property `memcleanup`.
- In containers, properly handle `/run/systemd/resolve`,
  which is necessary for DNS resolution on systems with `systemd-resolved`.
- Avoid warnings for mountpoints below inaccessible directories in containers.
- Improvements for handling `NaN` and `Inf` values in `table-generator`.
- Log output of BenchExec will now have colors if `coloredlogs` is installed.
- New tool-info modules and updates for SV-COMP'19.


## BenchExec 1.16

- Support for [energy measurements](https://github.com/sosy-lab/benchexec/blob/master/doc/resources.md#energy)
  if [cpu-energy-meter](https://github.com/sosy-lab/cpu-energy-meter) is installed.
- Several small bug fixes and improvements


## BenchExec 1.15 (skipped)


## BenchExec 1.14

- Updated tool-info modules for all participants of [SV-COMP'18](https://sv-comp.sosy-lab.org/2018/).
- Extended support for variable replacements in table-definitions
  of table-generator.


## BenchExec 1.13

- For Debian/Ubuntu, the `.deb` package is now the recommended way
  of [installation](https://github.com/sosy-lab/benchexec/blob/master/doc/INSTALL.md),
  because it automatically configures cgroups as necessary.
- BenchExec now automatically attempts to use the sub-cgroup
  `system.slice/benchexec-cgroup.service` if it does not have access
  to the current cgroup.
  This means that if you followed our installation instructions
  for systems with systemd, there is no need anymore to manually
  put your shell into the correct cgroup.
- Several smaller bug fixes for table-generator:
  [#249](https://github.com/sosy-lab/benchexec/issues/249),
  [#250](https://github.com/sosy-lab/benchexec/issues/250),
  [#259](https://github.com/sosy-lab/benchexec/issues/259),
  [#260](https://github.com/sosy-lab/benchexec/issues/260),
  [#271](https://github.com/sosy-lab/benchexec/issues/271),
  [#272](https://github.com/sosy-lab/benchexec/issues/272)
- For users of the Python API of RunExecutor,
  different file names can now be specified for stdout and stderr
  of the tool.
- Some new tool-info modules and updates for SV-COMP'18.


## BenchExec 1.12

- Fix execution of runs specified with `<withoutfile>` tags
  in the benchmark definition: the name of the run was missing
  from the command-line in BenchExec 1.11.

## BenchExec 1.11

- `table-generator` can now be given result XML files as arguments
  in addition to a table-definition XML file (with parameter `-x`).
  In this case, it will use the column definitions from the latter
  for tables with the separately given results.
- The directory `contrib` of the repository now contains a script
  [`statistics-tex.py`](https://github.com/sosy-lab/benchexec/blob/master/contrib/statistics-tex.py),
  which can export summary data for benchmark results
  (e.g., number of solved tasks, average CPU time, etc.)
  to LaTeX.
- The dummy tools `true` and `false`, which could be used for testing
  a BenchExec installation, are replaced with a more generic dummy tool
  called `dummy`.
- A few minor bug fixes and performance optimizations.

A new paper about BenchExec called
[Reliable Benchmarking: Requirements and Solutions](https://www.sosy-lab.org/~dbeyer/Publications/2017-STTT.Reliable_Benchmarking_Requirements_and_Solutions.pdf)
is now available.

Please note that support for Python 3.2 and 3.3 is deprecated.
Furthermore, the support for "sudo mode" (parameter `--user`/`--users`)
is also deprecated.
All deprecated features will be removed in BenchExec 2.0.


## BenchExec 1.10

This release brings several smaller and medium-sized features:

- Tool-info modules for all participants of [SV-COMP'17](https://sv-comp.sosy-lab.org/2017/),
  and support for results of the category `correct-unconfirmed`,
  which is used by SV-COMP if witness validation was not successful.
  To conform with SV-COMP's definitions, violations of the SV-COMP reachability property `unreach-call`
  will now be reported as `false(unreach-call)` instead of `false(reach)`.
- [Measurement of block I/O](https://github.com/sosy-lab/benchexec/blob/master/doc/resources.md#disk-space-and-io) if the `blkio` cgroup controller is available
  (experimental, please read the [documentation](https://github.com/sosy-lab/benchexec/blob/master/doc/resources.md#disk-space-and-io)!).
- [Measurement of the energy used by the CPU](https://github.com/sosy-lab/benchexec/blob/master/doc/resources.md#energy) for a run,
  if the tool [cpu-energy-meter](https://github.com/sosy-lab/cpu-energy-meter) is installed on the system
  (experimental, please read the [documentation](https://github.com/sosy-lab/benchexec/blob/master/doc/resources.md#energy)!).
- [Ability to limit the disk space](https://github.com/sosy-lab/benchexec/blob/master/doc/resources.md#disk-space-and-io) a tool can occupy in container mode.
- Various minor improvements to make container mode more robust.
- The feature for executing benchmarks under different user accounts with sudo
  is now marked as deprecated and may be removed in the future,
  consider using the container mode instead for isolating runs
  (cf. [issue #215](https://github.com/sosy-lab/benchexec/issues/215)).
- `table-generator` is now more flexible:
  - Builtin support for certain unit conversions,
    such that the scale factor does not always need to be explicitly specified.
    Furthermore, unit conversions now work even if the values already have a unit.
  - Column titles can be manually specified with the `displayTitle` attribute.
  - What columns are relevant for the "diff" table can be configured.

Please also note that we are considering dropping the support for Python 3.2
and maybe 3.3 in BenchExec 2.0 (to be released in a few weeks).
If this is a problem for you, please tell us in [issue #207](https://github.com/sosy-lab/benchexec/issues/207).


## BenchExec 1.9

The main feature of this release is the addition of a [container mode](https://github.com/sosy-lab/benchexec/blob/master/doc/container.md)
that allows to isolate runs from each other and from the host,
for example preventing filesystem and network accesses.
It also allows to collect and store all files created by the tool in a run.
The container mode is still in beta and disabled by default for now,
it will be enabled by default in BenchExec 2.0.
Please try it out and tell us your experiences!

Further changes:
- `table-generator` now supports HTTP(S) URLs to be given for result XML files
  to allow generating tables for results without needing to download them first.
  The HTML tables will contain correct links to the log files.
- New SV-COMP property deadlock supported by `benchexec`.
- The parameters `--rundefinition` and `--tasks` of `benchexec` now support wildcards.
- Rounding of very small and very large values in `table-generator` has been fixed.
- The default font for HTML tables has changed,
  it is now a font that supports correctly aligned digits.

## BenchExec 1.8

- `benchexec` now compresses results by default: XML result files
  are compressed with BZip2, and log files are stored within a ZIP archive.
  This can reduce the necessary disk space significantly
  (typically these logs compress very well),
  and for large benchmark sets it reduces the number of necessary files,
  which can make dealing with the results much faster.
  The previous behavior can be restored with the parameter `--no-compress-results`.
- `table-generator` now supports benchmark results where the log files
  are stored in a ZIP file instead of a regular directory.
  All features continue to work with compressed results,
  including extraction of values from log files and viewing log files from HTML tables
  (cf. [table-generator documentation](https://github.com/sosy-lab/benchexec/blob/master/doc/table-generator.md) for more details).
  Compressed and uncompressed results are handled transparently and can be mixed,
  and using results that were manually compressed or decompressed
  is also supported.

## BenchExec 1.7

- Fix `table-generator` behavior for columns where different cells have different units:
  The release notes for 1.6 claimed that these columns are treated as text column,
  when instead they were rejected. Now they are treated as text.
  Note that BenchExec does not create such columns itself, so this should not affect most users.
- Fix computation of scores according to the SV-COMP scoring scheme:
  if the expected result is for example `false(valid-deref)` and the tool returns `false(valid-free)`,
  the resulting score is the one for a wrong false answer (-16 points),
  not the one for a wrong true answer (-32 points).
  The latter score is only given if the tool actually answers `true` incorrectly.
- Change result classification, if the returned answer does not belong to the property of the task,
  for example, if the tool returns `true` instead of `sat` for a task with category `satisfiability`,
  or if the tool returns `false(no-overflow)` when it should not even check for overflows.
  Now these results are classified as unknown (with score 0),
  previously these were treated as wrong answers.
- Fix escaping of links in HTML tables, e.g., to log files with special characters in their name.
  This was broken in 1.6.

## BenchExec 1.6

This release brings several improvements to `table-generator`:
- `table-generator` now rounds measurement values in a scientifically correct way,
  i.e., with a fixed number of significant digits, not with a fixed number of decimal places.
  The attribute `numberOfDigits` of `<column>` tags in table-definition files
  now also specifies significant digits, not decimal places.
  By default, in HTML tables all fractional values are now rounded (e.g., time measurements)
  and all integer values continue without rounding (e.g., memory measurements),
  previously only "time" columns were rounded.
  The remaining rounding-related behavior stays unchanged:
  In CSV tables, values are not rounded by default,
  and if `numberOfDigits` is explicitly given for a column,
  it's value will always be rounded in both HTML and CSV tables.
- `table-generator` now automatically extracts units from the cells in a column
  and puts them into the table header.
- In HTML tables, numeric values are now aligned at the decimal point,
  and text values are left aligned (previously both were right aligned).
- `table-generator` now allows to convert values from one unit into another.
  So far this is only implemented for values that do not have a unit attached to them,
  and both the target unit and the scale factor need to be specified explicitly
  in the `<column>` tag.
  This can be used for example to show memory measurements in MB instead of Bytes in tables.
- `table-generator` now allows columns with links to arbitrary files to be added to tables.
- `table-generator` does not handle columns where cells have differing units wrongly anymore.
  Previously, the unit was simply dropped, leading to wrong values for statistics.
  Now such columns are treated as text and no statistics are generated.
  (Note that BenchExec never creates such columns by itself,
  only if values are extracted from the tool output this could happen).

Other changes:
- The behavior of `benchexec --timelimit` was changed slightly,
  if a value for `hardtimelimit` was given in the benchmark-definition file.
  If a time limit is specified on the command line, this now overrides both soft and hard time limit.
- Implementation of tool-info modules got easier because the `test_tool_info` helper got improved
  (it now allows to test the function for extracting results from tool outputs).
- Several tool-info modules of tools participating in SV-COMP got improved.
- Simplified cgroups setup for systemd systems.
- Improved documentation.

## BenchExec 1.5

- Improved definition of time and memory limits:
  Both can now be specified including units such as "s", "min" / "MB", "GB".
  to make them easier to read and less ambiguous.
  The old input format without units is still valid.
- runexec now allows enabling other cgroup subsystems and setting arbitrary cgroup options.
- HTML tables gained the possibility for inverting row filters.
- Improve detection of out-of-memory situations (were not always reported as OOM).
- External resources in HTML tables are loaded from HTTPS URLs
  such that browsers do not complain because of mixed content when viewing tables via HTTPS.
- Improved warnings for swapping and CPU throttling for benchexec.
- Various improvements to internal handling of memory values,
  they are not consistently stored as bytes
  (this only affects extensions of BenchExec, not regular input and output for users).

## BenchExec 1.4

- BenchExec moved to https://github.com/sosy-lab/benchexec
- Fix several bugs in table-generator introduced in version 1.3.
- BenchExec now creates fresh empty directories for $HOME and $TMPDIR
  of all runs, and removes them afterwards.
- table-generator now transparently supports result XML files as input
  that are compressed with GZip or BZip2.
- benchexec now reports some more information as status when a tool crashes,
  e.g. whether it segfaulted or aborted, and what the exit code was
  (previously this was only done for some tools).
- If a tool produces a result but still violates a resource limit,
  this is now shown in the status (but still counted as timeout / out of memory).
- Added dummy tool "calculatepi" that needs no input files and no installation,
  but can be used to create some CPU load and test benchmarking
  (it calculates Pi up some arbitrary number of digits using the tool "bc").
- Renaming "tool wrapper" to "tool info".
  This is mostly an internal and documentation change, but the utility
  `benchexec.test_tool_wrapper` is now named `benchexec.test_tool_info`.

## BenchExec 1.3

- Fix core assignment on AMD Bulldozer/Piledriver Opterons.
- Measure and report CPU time usage per core
  (hidden by default in tables, use `table-generator --all-columns` to show).
- Parameter `--user` allows executing benchmarks under a different user
  (cf. https://github.com/sosy-lab/benchexec/blob/master/doc/separate-user.md).
- Performance improvements for table-generator,
  including parallel processing of input and output files and statistics.
- HTML Tables support filtering rows by task name.
- Improved statistics in HTML tables: median is now the arithmetic median,
  unnecessary rounding removed, standard deviation added,
  and missing results are not counted as "0" but ignored in calculation.
- New utility for testing tool wrappers, making it easier to add support
  for new tools.
- Several new modules for integration of various software verifiers.

## BenchExec 1.2

- BenchExec now records whether TurboBoost was enabled during benchmarking.
- Updated SV-COMP scoring scheme to SV-COMP 2016.
- Support new property 'no-overflow' for SV-COMP 2016.
- Several new modules for integration of various software verifiers.
- Some improvements to CPU-core assignment.

## BenchExec 1.1

- HTML tables produced by table-generator now have a header that stays
  always visible, even when scrolling through the table.
- A Debian package is now created for releases and made available on GitHub.
- Small bug fixes.

## BenchExec 1.0

- Multiple runs for the same file can now be shown in the table in different rows
  if they have different properties or ids.
- Helper files for generating scatter and quantile plots with Gnuplot added.
- Doctype declarations are now used in all XML files.
- Statistics output at end of benchexec run was wrong.

## BenchExec 0.5

- Allow to redirect stdin of the benchmarked tool in runexec / RunExecutor
- Fix bug in measurement of CPU time
  (only occurred in special cases and produced a wrong value below 0.5s)
- Improve utility command for checking cgroups to work around a problem
  with cgrulesngd not handlings threads correctly.

## BenchExec 0.4

- Support for integrating SMTLib 2 compliant SMT solvers and checking the expected output.
- runexec now supports Python 2 again.
- table-generator allows to selected desired output formats and supports output to stdout.
- Added utility command for checking if cgroups have been set up correctly.
- Avoid "false posititive/negative" and use "incorrect false/true" instead.
- Command-line arguments to all tools can be read from a file given with prefix "@".
- Bug fixes and performance improvements.

## BenchExec 0.3

- HTML tables now have header with direct access to plots.
- Maximum score of table is generated again.
- table-generator can now extract statistic values for other tools, too (not only CPAchecker).
- More flexible time limit specifications.
- Warnings shown if system swaps or throttles during benchmarking.
- Improved reliability of benchmarking: forbid swapping, use freezer to kill processes atomically.
- Renamed `<sourcefiles>` tag to `<tasks>` in benchexec input.
- Bug fixes.
- Added documentation.
- Added more tests.


## BenchExec 0.2

- bug fixes
- switch to Python 3 completely


## BenchExec 0.1

Initial version of BenchExec as taken from the repository of CPAchecker.
