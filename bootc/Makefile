##
# Makefile for building OCI bootc images
#
# @file
# @version 0.1

all: fcos-base

clean:
	podman image rm \
		localhost/fcos-base:latest

fcos-base:
	podman build -t localhost/fcos-base:latest ./fcos-base/ && \
	podman push --tls-verify=false localhost/fcos-base:latest docker://localhost:5000/localhost/fcos-base

.PHONY: fcos-base


# end
