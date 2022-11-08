#!/bin/bash

set -e

VERSION=$1

if [ -z "$VERSION" ]; then
    echo "Usage: build.sh VERSION"
    exit 1
fi

docker buildx build --progress=plain \
     --platform linux/amd64,linux/arm64 \
     --build-arg VERSION=${VERSION} \
     --output type=image,name=type=image,push=true \
     -t g67261831/snell-server-docker . --no-cache