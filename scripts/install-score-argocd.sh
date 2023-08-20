#!/bin/bash -eu
set -euo pipefail

# The script installs the score-argocd cli tool

arch=$(uname -m)
if [[ "$arch" == x86_64* ]]; then
  platform="x86-64"
elif [[ "$arch" == i*86 ]]; then
  platform="i386"
elif  [[ "$arch" == arm* || "$arch" == aarch* ]]; then
  platform="arm64"
fi

url=europe-west1-docker.pkg.dev/deimos-registry/deimos-docker-registry/score-argocd-linux-$platform:latest

oras pull $url 
sudo tar -xvf dist/*.tar.gz -C /usr/local/bin/
chmod +x /usr/local/bin/score-argocd
rm -rf dist

