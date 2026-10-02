# coreos-demo

Demo on how one can provision Fedora CoreOS virtual machines (and RHEL CoreOS with some adjustments).

The repository was developed in tagged chapters for the narrative of the presentation (`./presentation`).

To follow along, it is assumed that the consumer is running on a Linux host (preferably Fedora-derived) 
and has a grab bag of software packages preinstalled. More on specific software package prerequisites under
each chapter.

## Chapter 1 - Ignition

Butane configs are transpiled to Ignition, a FCOS live ISO is downloaded and
customized, and the VM is launched with libvirt.

## Prerequisites

The following commands must be available on the host to run the Makefiles and
scripts in this repository chapter:

| Command | Used for | Typical package |
|---|---|---|
| `make` | Build orchestration (top-level and sub-Makefiles) | `make` |
| `podman` | Runs the `butane` and `coreos-installer` container images | `podman` |
| `python` | `make serve` (`python -m http.server`) | `python3` |
| `virt-install` | Creating/booting the VM (`machines/fcos205/run.sh`) | `virt-install` |
| `virsh` | Managing libvirt domains (`run.sh`) | `libvirt-client` |
| `qemu-img` | Creating the VM disk image (`run.sh`) | `qemu-img` |
| `virt-viewer` | Graphical console (presence checked by `run.sh`) | `virt-viewer` |

Standard GNU coreutils (`find`, `rm`, `mv`, `printf`, `dirname`) are also used
and assumed present on any Linux host.

Note: `butane` and `coreos-installer` are *not* host prerequisites; they are
pulled and executed as container images (`quay.io/coreos/butane:latest`,
`quay.io/coreos/coreos-installer:release`) via `podman`.

## Usage

```sh
make            # build Ignition files, download FCOS ISO
make customize  # embed boot Ignition into the ISO
make serve      # serve files over HTTP (for Ignition fetch)
make up         # launch the VM via libvirt
make clean      # remove generated .ign files
make distclean  # also remove downloaded ISO artifacts
```
