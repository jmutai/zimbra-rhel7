IMAGE=zimbra-rhel-base

.PHONY: all build

all: build

build:
	docker build --rm -t $(IMAGE) .
