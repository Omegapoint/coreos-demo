##
# @file
# @version 0.1
BUTANE_IMAGE=quay.io/coreos/butane:latest

# common/core-user
CORE_USER_DIR=common/core-user
CORE_USER_BUTANE=$(CORE_USER_DIR)/config.bu
CORE_USER_IGNITION=$(CORE_USER_DIR)/config.ign

all: $(CORE_USER_IGNITION)

$(CORE_USER_IGNITION): $(CORE_USER_BUTANE)
	podman run \
		-i \
		--rm \
		-v ./$(CORE_USER_DIR):/root/butane:ro,Z \
		$(BUTANE_IMAGE) \
		--strict \
		--files-dir /root/butane < $(CORE_USER_BUTANE) > $(CORE_USER_IGNITION)

clean:
	find . -type f -name '*.ign' -exec rm -- {} +

# end
