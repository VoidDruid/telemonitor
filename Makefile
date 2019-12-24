IMAGE_NAME = telemonitor

.PHONY: bind build run build_docker

bind:
	python scripts/generate_bindings.py

build: bind
	stack build 

run: build
	stack run

build_docker: bind
	docker build -t $(IMAGE_NAME) .
