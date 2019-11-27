GEN_BIND = python scripts/generate_bindings.py

bind:
	$(GEN_BIND)

build: bind
	stack build 

run: build
	stack run
