.PHONY: bind build run

bind:
	python scripts/generate_bindings.py

build: bind
	stack build 

run: build
	stack run
