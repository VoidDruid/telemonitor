GEN_BIND = "python scripts/generate_bindings.py"

build:
	stack build --exec $(GEN_BIND)

run: build
	stack run
