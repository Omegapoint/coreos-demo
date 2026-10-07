##
# @file
# @version 0.1
BUTANE_IMAGE=quay.io/coreos/butane:latest

# common/core-user
CORE_USER_DIR=common/core-user
CORE_USER_BUTANE=$(CORE_USER_DIR)/config.bu
CORE_USER_IGNITION=$(CORE_USER_DIR)/config.ign

# common/containers-registry
CONTAINERS_REGISTRY_DIR=common/containers-registry
CONTAINERS_REGISTRY_BUTANE=$(CONTAINERS_REGISTRY_DIR)/config.bu
CONTAINERS_REGISTRY_IGNITION=$(CONTAINERS_REGISTRY_DIR)/config.ign

# k3s/cluster-server
CLUSTER_SERVER_DIR=k3s/cluster-server
CLUSTER_SERVER_IGNITION=$(CLUSTER_SERVER_DIR)/config.ign
CLUSTER_SERVER_FILES=$(shell find $(CLUSTER_SERVER_DIR) -type f ! -name '*.ign')

all: $(CORE_USER_IGNITION) $(CONTAINERS_REGISTRY_IGNITION) $(CLUSTER_SERVER_IGNITION)

$(CORE_USER_IGNITION): $(CORE_USER_BUTANE)
	podman run \
		-i \
		--rm \
		-v ./$(CORE_USER_DIR):/root/butane:ro,Z \
		$(BUTANE_IMAGE) \
		--strict \
		--files-dir /root/butane < $(CORE_USER_BUTANE) > $(CORE_USER_IGNITION)

$(CONTAINERS_REGISTRY_IGNITION): $(CONTAINERS_REGISTRY_BUTANE)
	podman run \
		-i \
		--rm \
		-v ./$(CONTAINERS_REGISTRY_DIR):/root/butane:ro,Z \
		$(BUTANE_IMAGE) \
		--strict \
		--files-dir /root/butane < $(CONTAINERS_REGISTRY_BUTANE) > $(CONTAINERS_REGISTRY_IGNITION)

$(CLUSTER_SERVER_IGNITION): $(CLUSTER_SERVER_FILES)
	podman run \
		-i \
		--rm \
		-v ./$(CLUSTER_SERVER_DIR):/root/butane:ro,Z \
		$(BUTANE_IMAGE) \
		--strict \
		--files-dir /root/butane < $(CLUSTER_SERVER_DIR)/config.bu > $(CLUSTER_SERVER_IGNITION)

clean:
	find . -type f -name '*.ign' -exec rm -- {} +

# end
