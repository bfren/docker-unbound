#!/bin/sh

IMAGE=`cat VERSION`

docker buildx build \
    --load \
    --no-cache \
    --progress plain \
    --build-arg BF_IMAGE=unbound \
    --build-arg BF_VERSION=${IMAGE} \
    -f Dockerfile \
    -t unbound-dev \
    . \
    && \
    docker run -it -e BF_DEBUG=1 -e BF_UNBOUND_ENABLE_DNSSEC=1 -p "127.0.0.1:5353:53/udp" unbound-dev sh
