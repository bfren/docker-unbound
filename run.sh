#!/bin/sh

IMAGE=`cat VERSION`

docker buildx build \
    --load \
    --build-arg BF_IMAGE=unbound \
    --build-arg BF_VERSION=${IMAGE} \
    -f Dockerfile \
    -t unbound-dev \
    . \
    && \
    docker run -it unbound-dev sh
