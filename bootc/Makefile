##
# Makefile for building OCI bootc images
#
# @file
# @version 0.1

all: fcos-base fcos-k3s

clean:
	podman image rm \
		localhost/fcos-base:latest \
		localhost/fcos-k3s:latest

fcos-base:
	podman build -t localhost/fcos-base:latest ./fcos-base/ && \
	podman push --tls-verify=false localhost/fcos-base:latest docker://localhost:5000/localhost/fcos-base

fcos-k3s:
	podman build -t localhost/fcos-k3s:latest ./fcos-k3s/ && \
	podman push --tls-verify=false localhost/fcos-k3s:latest docker://localhost:5000/localhost/fcos-k3s

.PHONY: fcos-base fcos-k3s


# end
