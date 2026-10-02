##
# @file
# @version 0.1
MACHINE_VALUES=./machine.values.yaml
BUTANE_IMAGE=quay.io/coreos/butane:latest
COREOS_INSTALLER_IMAGE=quay.io/coreos/coreos-installer:release

MACHINE_NAME=fcos205
MACHINE_IMAGE_SIZE=10G

COREOS_STREAM=next
COREOS_ARCH=x86_64
COREOS_PLATFORM=metal
COREOS_FORMAT=iso
COREOS_IMAGE=fedora-coreos-$(COREOS_STREAM)-$(COREOS_PLATFORM).$(COREOS_ARCH).iso

BOOT_BUTANE=boot.bu
BOOT_IGNITION=boot.ign

INSTALL_BUTANE=install.bu
INSTALL_IGNITION=install.ign

all: $(INSTALL_IGNITION) $(BOOT_IGNITION) $(COREOS_IMAGE)

customize:
	podman run \
		--rm --security-opt label=disable -v .:/data -w /data \
		$(COREOS_INSTALLER_IMAGE) iso ignition embed \
		--ignition-file=$(BOOT_IGNITION) --force $(COREOS_IMAGE)

$(INSTALL_IGNITION): $(INSTALL_BUTANE)
	podman run \
		-i \
		--rm \
		$(BUTANE_IMAGE) \
		--strict \
		< $(INSTALL_BUTANE) > $(INSTALL_IGNITION)

$(BOOT_IGNITION): $(BOOT_BUTANE)
	podman run \
		-i \
		--rm \
		$(BUTANE_IMAGE) \
		--strict \
		< $(BOOT_BUTANE) > $(BOOT_IGNITION)

$(COREOS_IMAGE):
	podman run --rm --security-opt label=disable \
		-v .:/data -w /data \
		$(COREOS_INSTALLER_IMAGE) download \
		--stream=$(COREOS_STREAM) \
		--architecture=$(COREOS_ARCH) \
		--format=$(COREOS_FORMAT) \
		--platform=$(COREOS_PLATFORM) \
		--decompress \
		--fetch-retries=10 \
	&& mv --verbose fedora-coreos-*.$(COREOS_ARCH).iso $(COREOS_IMAGE)

clean:
	find . -maxdepth 1 -type f \( -name '*.ign' \) -exec rm --verbose -- {} +

distclean: clean
	find . -maxdepth 1 -type f \( -name '*.iso' -o -name '*.sig' -o -name '*.xz' -o -name '$(COREOS_IMAGE)' \) -exec rm --verbose -- {} +

.PHONY: all customize clean distclean

# end
