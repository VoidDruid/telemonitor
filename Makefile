IMAGE_NAME = telemonitor

.PHONY: bind build run build_docker

bind:
	python scripts/generate_bindings.py

build: bind
	stack build 

run: bind
	stack run

build_docker: build  # TODO: should depend on bind, and perform build inside the container
	docker build -t $(IMAGE_NAME) .
