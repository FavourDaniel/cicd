#!/bin/bash -eu
set -euo pipefail

# The script builds the docker image and pushes it to the local docker registry.

tag='0.0.1'

docker build ./src/node-web-app --tag node-web-app:$tag

docker tag node-web-app:$tag localhost:5000/node-web-app:$tag

docker push localhost:5000/node-web-app:$tag

# loadgenerator

docker build ./src/loadgenerator --tag loadgenerator:latest

docker tag loadgenerator:latest localhost:5000/loadgenerator:latest

docker push localhost:5000/loadgenerator:latest
