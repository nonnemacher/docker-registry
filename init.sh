#!/bin/bash

port="5000:5000"
container_name="registry"
path="/opt/registry"
image="registry:2"
user="123"
pass="123"
docker="/usr/bin/docker"

docker pull ${image}

docker run \
  --entrypoint htpasswd \
  ${image} -Bbn ${user} ${pass} > ${path}/auth/htpasswd

docker run -d -p ${port} \
        --restart=always \
        --name ${container_name} \
        -v ${path}/auth:/auth \
        -e "REGISTRY_AUTH=htpasswd" \
        -e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
        -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd \
        ${image}
