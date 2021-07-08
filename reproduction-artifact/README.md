# Reproduction Package

## Stochastic Boolean Satisfiability: Decision Procedures, Generalization, and Applications

## Abstract

This artifact is a reproduction package for Nian-Ze Lee's Ph.D. dissertation
"Stochastic Boolean Satisfiability: Decision Procedures, Generalization, and Applications".

It contains code and data used in the experiments of the dissertation,
including the evaluated tools,
the benchmark suites,
the scripts to run the experiments,
the raw data generated from the experiments,
and instructions for reproducing the tables and figures in the dissertation.

A full reproduction of the experiments requires 16 GB of memory and several weeks of CPU time,
but demonstrative runs can be executed if at least 4 GB of memory are available.

This artifact is published at _TODO_.

In the following, we shall assume the users of this artifact having basic knowledge about Linux command-line interface and virtual machines.

## Content

This artifact contains the following items:

- `README.*`: this documentation
- `LICENSE`: license information of the artifact
  dissertation
- `Nian-Ze.Lee.Dissertation.pdf`: a preprint of the dissertation
- `Makefile`: a file to execute the commands
- `ssatABC/`: a directory containing the source code for the proposed SSAT solvers at commit [`master:2ff8e74`][code-commit] of the repository [NTU-ALComLab/ssatABC][code-repo]
- `bin/`: a directory containing the following binaries
  - `abc`: the proposed SSAT solvers BDDsp, reSSAT, and erSSAT
  - `dcssat`: a state-of-the-art DPLL-based SSAT solver [DC-SSAT][dc-ssat]
  - `cachet`: a classic weighted model counter [Cachet][cachet]
  - `approxmc`: [version 4.0.1][approxmc-4.0.1] of a state-of-the-art approximate model counter [ApproxMC][approxmc]
- `ssat-benchmarks/`: a directory containing the SSAT benchmark suite used in our evaluation (at commit [`main:ea9fbae`][benchmark-commit] of the repository [NTU-ALComLab/ssat-benchmarks][benchmark-repo])
- `PPE-benchmarks`: a directory containing the PEC and MPEC benchmark suites used in our evaluation (at commit [`master:2ff8e74`][code-commit] of the repository [NTU-ALComLab/ssatABC][code-repo])
- `tool-info/`: a directory containing the tool-info modules for [DC-SSAT][dc-ssat], [Cachet][cachet], and [ApproxMC][approxmc]
- `test-sets/`: a directory containing the XML benchmark definitions of the experiments for [BenchExec][benchexec]
- `thesis-data/`: a directory containing the raw data generated from our experiments, XML table-definitions, and HTML tables

This readme file will guide you through the following steps:

1. Setup of the environment
2. Performing experiments in the dissertation
3. Analyzing the experimental data

## 1. Environmental Setup

This artifact requires Linux and was tested and works best with Ubuntu 20.04.
You could create such an environment using a virtual machine.
In the following, we will use [Ubuntu 20.04.2][ubuntu] and [VirtualBox][virtualbox], and all the listed commands are executed in the root directory of this artifact.

### Hardware

Please provide at least 4 GB of memory for the demo experiments.
The full experiments need 16 GB of memory.
A disk space of 10 GB is recommended.
An internet connection is necessary to install other dependencies.

### Software

- BenchExec

  To install BenchExec, please follow its [installation instructions](https://github.com/sosy-lab/benchexec/blob/master/doc/INSTALL.md).
  The critical steps are listed below:

  ```shell
  sudo add-apt-repository ppa:sosy-lab/benchmarking
  sudo apt install benchexec
  ```

  After the installation, add your user account to the `benchexec` group:

  ```
  sudo adduser `whoami` benchexec
  ```

  For the operation of adding a user to take effect, please **reboot** the system afterwards.
  To test if the permission of cgroup needed by BenchExec is correctly configured, please run:

  ```shell
  python3 -m benchexec.check_cgroups
  ```

  No warnings or error messages should be printed if the permission is correctly configured.
  If there are still permission problems, please have a look at the [BenchExec installation documents](https://github.com/sosy-lab/benchexec/blob/master/doc/INSTALL.md).

  Additional preparation for BenchExec is **required after each reboot**.
  Please turn off the swap memory using the following command:

  ```shell
  sudo swapoff -a
  ```

  To benchmark `dcssat`, `cachet`, and `approxmc`, additional tool-info modules are required.
  Please append the path to the parent directory of `tool-info/` (i.e., the root directory of this artifact) to the environment variable `PYTHONPATH`:

  ```shell
  export PYTHONPATH=$PYTHONPATH:`pwd`
  ```

- Makefile

  We will use Makefile to execute the scripts for experiments.
  Please install Makefile with the following command:

  ```shell
  sudo apt install make
  ```

- VirtualBox Guest Additions (optional)

  We recommend to install VirtualBox guest additions to resize the VM window and to enable shared folders between the host and guest OS.

  Before installing the guest additions, please download the following packages to compile the external kernel modules:

  ```shell
  sudo apt update
  sudo apt install build-essential
  sudo apt install linux-headers-`uname -r`
  ```

  After restarting the VM and setting the path to the shared folder in the host OS and its name (an identifier used by the mount command, `shared` for example), use the following command to mount the shared folder (`~/Shared/` for example) in the guest OS:

  ```shell
  sudo mount -t vboxsf -o uid=1000,gid=1000 shared ~/Shared/
  ```

## 2. Performing Experiments

We provide binaries for the following tools, either pre-compiled or contained in commit [`master:2ff8e74`][code-commit] from the repository [NTU-ALComLab/ssatABC][code-repo]:

- `abc`: BDDsp, reSSAT, and erSSAT
- `dcssat`
- `cachet`
- `approxmc`

The above tools should work out-of-the-box if the environment has been setup correctly.

Before you execute any experiment, please make sure that:

1. The cgroup permission is correctly configured
2. The swap memory is turned off
3. The environmental variable `PYTHONPATH` is appended by the path to the parent directory of `tool-info/`

### Experimental Settings

The experiments in the dissertation were performed on a machine with one 2.2 GHz CPU (Intel Xeon Silver 4210) with 40 processing units and 134,616 MB of RAM.
Each task was limited to a CPU core, a CPU time of 15 min, and a memory usage of 15 GB.
To reduce the elapsed wall-clock time, the tasks were executed in parallel on 8 threads, achieved by BenchExec's command-line option `--numOfThreads <n>`.

Given the limited computational resources,
one may consider overriding the default settings of the time and memory limits.
We recommend to use a CPU time limit of 60 sec and a memory usage of 3 GB for demonstration purposes:

```shell
make timelimit=60s memlimit=3GB <Makefile target>
```

The raw data generated from your runs will be stored in directory `results/`.
You can type `make clean` to delete them.

### PPE Experiments (Chapter 4)

The full experiments can be reproduced by running:

```shell
make ppe-experiments
```

This command will invoke BDDsp, DC-SSAT, Cachet, and ApproxMC over all PEC tasks, and BDDsp and DC-SSAT over all MPEC tasks.

### RE-SSAT Experiments (Chapter 5)

The full experiments can be reproduced by running:

```shell
make ressat-experiments
```

This command will invoke DC-SSAT, reSSAT, and reSSAT-b over all RE-SSAT tasks, including `Random`, `Strategic`, and `PEC` families.

### ER-SSAT Experiments (Chapter 6)

The full experiments can be reproduced by running:

```shell
make erssat-experiments
```

This command will invoke DC-SSAT, erSSAT, and erSSAT-b over all ER-SSAT tasks, including `Random` and `Application` families.

## 3. Analyzing Data

The directory `thesis-data/` contains all of the raw data collected from the experiments and HTML tables corresponding to the figures and tables in the dissertation.
The HTML tables were generated by the `table-generator` of BenchExec.

### PPE Experiments (Chapter 4)

For Tables 4.7, 4.8, 4.9, 4.10 in the thesis, please run:

```shell
make ppe-tables
```

### RE-SSAT Experiments (Chapter 5)

For Figures 5.1, 5.2, 5.3 and Tables 5.4, 5.5 in the thesis, please run:

```shell
make ressat-tables
```

### ER-SSAT Experiments (Chapter 6)

For Figures 6.1, 6.2, 6.3 and Tables 6.4, 6.5, 6.6 in the thesis, please run:

```shell
make erssat-tables
```

To generate HTML tables from your own runs, please modify the table-definition XML files in directory `thesis-data/` (via changing the filename fields) and run:

```shell
table-generator -f html --no-diff -x <path to the modified XML file>
```

The generated HTML tables can be viewed by a web browser, e.g., Firefox.

[code-repo]: https://github.com/NTU-ALComLab/ssatABC
[code-commit]: https://github.com/NTU-ALComLab/ssatABC/commit/2ff8e7436222695679e17a769d515143507cea44
[benchmark-repo]: https://github.com/NTU-ALComLab/ssat-benchmarks
[benchmark-commit]: https://github.com/NTU-ALComLab/ssat-benchmarks/commit/ea9fbaeaeca42fc77d2b1385c94ae68273e7f7e0
[dc-ssat]: https://www.aaai.org/Papers/AAAI/2005/AAAI05-066.pdf
[cachet]: https://www.cs.rochester.edu/users/faculty/kautz/Cachet/index.htm
[approxmc]: https://github.com/meelgroup/approxmc
[approxmc-4.0.1]: https://github.com/meelgroup/approxmc/releases/tag/4.0.1
[benchexec]: https://github.com/sosy-lab/benchexec
[ubuntu]: https://releases.ubuntu.com/20.04/
[virtualbox]: https://www.virtualbox.org/wiki/VirtualBox
