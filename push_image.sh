#!/usr/bin/bash

# Push image to docker hub

image_name=telemonitor
version=0.1.0

registry_url=# REPO URL

docker build -t $image_name .
docker tag $image_name $registry_url/$image_name:$version
docker push $registry_url/$image_name%:$version
