##
# @file
# @version 0.1

all: images ignition machines customize

up:
	exec ./machines/fcos205/run.sh

images:
	make -C ./bootc/

machines: ignition
	make -C ./machines/fcos205/

ignition:
	make -C ./ignition/

customize:
	make -C ./machines/fcos205/ customize

serve:
	python -m http.server

clean:
	make -C ./ignition/ clean && \
	make -C ./machines/fcos205/ clean

distclean:
	make -C ./ignition/ clean && \
	make -C ./machines/fcos205/ distclean && \
	make -C ./bootc/ clean

presentation:
	cd ./docs && presenterm --config-file=presenterm.yaml presenterm.md

.PHONY: serve ignition machines install up presentation


# end
