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
but a limited subset of the benchmark tasks can be used for demonstration purposes
if at least 4 GB of memory are available.

This artifact is published at _TODO_.
In the following, we shall assume the users of this artifact to have basic knowledge about Linux command-line interface and virtual machines.

## Content

This artifact contains the following items:

- `README.*`: this documentation
- `LICENSE`: license information of the artifact
- `Nian-Ze.Lee.Dissertation.pdf`: a preprint of the dissertation
- `bin`: a directory containing the following binaries
  - `abc`: the proposed [SSAT solvers](https://github.com/NTU-ALComLab/ssatABC)
    at commit [`master:2ff8e74`](https://github.com/NTU-ALComLab/ssatABC/commit/2ff8e7436222695679e17a769d515143507cea44)
  - [`cachet`](https://www.cs.rochester.edu/users/faculty/kautz/Cachet/index.htm): a classic weighted model counter
  - [`dcssat`](https://www.aaai.org/Papers/AAAI/2005/AAAI05-066.pdf): a state-of-the-art DPLL-based SSAT solver
- `abc.rc`: a file that defines aliases used by `abc`
- `benchexec`: a directory containing a development version of [BenchExec](https://github.com/sosy-lab/benchexec), including the tool-info modules for `approxmc`, `cachet`, and `dc-ssat`
- `ssat-benchmarks`: a directory containing the SSAT benchmark suite used in our evaluation (at commit [`main:ea9fbae`](https://github.com/NTU-ALComLab/ssat-benchmarks/commit/ea9fbaeaeca42fc77d2b1385c94ae68273e7f7e0) of the repository [NTU-ALComLab/ssat-benchmarks](https://github.com/NTU-ALComLab/ssat-benchmarks))
- `PPE-benchmarks`: a directory containing the PEC and MPEC benchmark suites used in our evaluation (at commit [`master:2ff8e74`](https://github.com/NTU-ALComLab/ssatABC/commit/2ff8e7436222695679e17a769d515143507cea44) of the repository [NTU-ALComLab/ssatABC](https://github.com/NTU-ALComLab/ssatABC))
- `test-sets`: a directory containing the XML benchmark definitions of the experiments for [BenchExec](https://github.com/sosy-lab/benchexec)
- `thesis-data`: a directory containing the raw data generated from our experiments, XML table-definitions, and HTML tables
- `results`: a directory where BenchExec will put the benchmarking results (the directory is empty initially)
- `Makefile`: a file to execute the commands

This readme file will guide you through the following steps:

1. Setup of the environment
2. Performing experiments in the dissertation
3. Analyzing the experimental data

## 1. Setup

This artifact requires Linux and was tested and works best with Ubuntu 20.04.
You could create such an environment using a virtual machine.
In the following, we use [VirtualBox](https://www.virtualbox.org/wiki/VirtualBox) and [Ubuntu 20.04.2](https://releases.ubuntu.com/20.04/).

### Hardware

Please provide at least 4 GB of memory for the demo experiment.
The full experiment needs 16 GB of memory.
A disk space of 10 GB is recommended.
An internet connection is necessary to install other dependencies.

### Software

- VirtualBox Guest Additions (optional)

  We recommend to install VirtualBox guest additions to enable shared folders between the host and guest OS.

  Before installing the guest additions, please download the following packages to compile the external kernel modules:

  ```shell
  sudo apt update
  sudo apt install build-essential
  sudo apt install linux-headers-`uname -r`
  ```

  After restarting the VM and setting the path to the shared folder in the host OS and its name (identifier in the mount command), use the following command to mount the shared folder in the guest OS:

  ```shell
  sudo mount -t vboxsf -o uid=1000,gid=1000 <name> <shared folder path in guest OS>
  ```

- Git

  We will use Git to download other tools, e.g., `ApproxMC`.
  Please install Git with the following command:

  ```shell
  sudo apt install git
  ```

- Makefile

  We will use Makefile to execute the scripts for experiments.
  Please install Makefile with the following command:

  ```shell
  sudo apt install make
  ```

- BenchExec

  To install BenchExec, please follow its [installation instructions](https://github.com/sosy-lab/benchexec/blob/master/doc/INSTALL.md).
  The critical steps are listed below:

  ```shell
  sudo add-apt-repository ppa:sosy-lab/benchmarking
  sudo apt install benchexec
  ```

  After the installation, add your user to the `benchexec` group:

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

  To benchmark `DC-SSAT`, `Cachet`, and `ApproxMC`, additional tool-info modules are required.
  Please append the path to the provided development version of BenchExec to the environment variable PYTHONPATH:

  ```shell
  export PYTHONPATH=$PYTHONPATH:/path/to/your/local/benchexec
  ```

- ABC (containing SSAT solvers `bddsp`, `reSSAT`, and `erSSAT`)

  The provided binary is compiled at commit `2ff8e74` from the [ssatABC](https://github.com/NTU-ALComLab/ssatABC) repository.
  It should work out-of-the-box.

- DC-SSAT

  The provided binary is contained in commit `2ff8e74` from the [ssatABC](https://github.com/NTU-ALComLab/ssatABC) repository.
  It should work out-of-the-box.

- Cachet

  The provided binary is contained in commit `2ff8e74` from the [ssatABC](https://github.com/NTU-ALComLab/ssatABC) repository.
  It should work out-of-the-box.

- ApproxMC

  Please install ApproxMC-4.0.1 following its [instructions](https://github.com/meelgroup/approxmc#how-to-build).
  The crucial steps are as follows:

  ```
  sudo apt install build-essential cmake
  sudo apt install zlib1g-dev libboost-program-options-dev libm4ri-dev libgmp-dev
  git clone https://github.com/msoos/cryptominisat
  cd cryptominisat
  mkdir build && cd build
  cmake ..
  make
  sudo make install
  cd ../..
  git clone https://github.com/meelgroup/approxmc/
  cd approxmc
  mkdir build && cd build
  cmake ..
  make
  sudo make install
  ```

  Do NOT put the directories `cryptominisat` and `approxmc` in the shared folder.
  Otherwise, the installation will fail because of symbolic links.

## 2. Performing Experiments

### Experimental Settings

### Demo Run

### Full Run

## 3. Analyzing the Experimental Data
