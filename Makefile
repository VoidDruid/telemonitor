DOCKER_REPO = voidwalker/telemonitor
LOCAL_IMAGE_NAME = telemonitor
APP_NAME = telemonitor-exe

.PHONY: bind build run build_docker push_docker build_and_push

bind:
	python3 scripts/generate_bindings.py

build: bind
	stack build 

run: bind
	stack run

# not using "realpath" for MacOS compatibility
EXE_PATH = $(shell python3 -c "import os; print(os.path.relpath('$(shell stack exec -- which $(APP_NAME))', '.'))")
build_docker: build
	echo "Copying exe from $(EXE_PATH)"
	chmod 777 $(EXE_PATH)
	docker build --build-arg EXE_PATH=$(EXE_PATH) -t $(LOCAL_IMAGE_NAME) .

PUSH_AS = $(DOCKER_REPO):$(shell git rev-parse --short HEAD)
push_docker:
	echo "Uploading existing image"
	echo "Pushing as $(PUSH_AS)"
	docker tag $(LOCAL_IMAGE_NAME) $(PUSH_AS)
	docker push $(PUSH_AS)

build_and_push: build_docker push_docker