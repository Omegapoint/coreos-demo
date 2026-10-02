#!/usr/bin/env bash

set -euo pipefail

vm_name=${VM_NAME:-fcos205}
vm_memory_mib=${VM_MEMORY_MIB:-4096}
vm_vcpus=${VM_VCPUS:-2}
vm_disk_size=${VM_DISK_SIZE:-15G}
vm_disk="/var/lib/libvirt/images/$vm_name.qcow2"
vm_iso="/var/lib/libvirt/images/$vm_name.iso"

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
iso_path="$script_dir/fedora-coreos-next-metal.x86_64.iso"

for cmd in virt-install virsh qemu-img virt-viewer; do
    command -v "$cmd" >/dev/null || {
        printf '%s is required (Fedora packages: virt-install, libvirt-client, qemu-img, virt-viewer)\n' "$cmd" >&2
        exit 1
    }
done

if (( EUID != 0 )); then
    printf '%s\n' "Run this script as root: sudo ./run.sh" >&2
    exit 1
fi

if [[ ! -f $iso_path ]]; then
    printf 'Install ISO not found: %s\n' "$iso_path" >&2
    exit 1
fi

# Remove any pre-existing domain with the same name.
if virsh --connect qemu:///system dominfo "$vm_name" >/dev/null 2>&1; then
    virsh --connect qemu:///system destroy "$vm_name" >/dev/null 2>&1 || true
    virsh --connect qemu:///system undefine "$vm_name" --nvram >/dev/null 2>&1 \
        || virsh --connect qemu:///system undefine "$vm_name" >/dev/null
fi

# Keep libvirt's ownership changes away from the project's working ISO.
cp -- "$iso_path" "$vm_iso"

# (Re)create the disk image, replacing any existing one.
rm -f -- "$vm_disk"
qemu-img create -f qcow2 -- "$vm_disk" "$vm_disk_size"

exec virt-install \
    --connect qemu:///system \
    --name "$vm_name" \
    --memory "$vm_memory_mib" \
    --vcpus "$vm_vcpus" \
    --os-variant fedora-coreos-next \
    --disk "path=$vm_disk,format=qcow2,bus=virtio" \
    --cdrom "$vm_iso" \
    --network network=default,model=virtio \
    --graphics spice \
    --virt-type kvm \
    --autoconsole graphical
