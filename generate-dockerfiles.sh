#!/bin/bash

set -euo pipefail

docker pull bfren/alpine

BASE_VERSION="7.0.0-dev"
echo "Base: ${BASE_VERSION}"

# Alpine edition must match the one bfren-bin/unbound is compiled against
ALPINE_EDITION="3.24"
UNBOUND_REVISION=`cat ./overlay/tmp/UNBOUND_REVISION`
UNBOUND_BUILD="261021"
echo "Unbound ${UNBOUND_REVISION} for Alpine ${ALPINE_EDITION}"

DOCKERFILE=$(docker run \
    -v ${PWD}:/ws \
    -e BF_DEBUG=0 \
    bfren/alpine esh \
    "/ws/Dockerfile.esh" \
    ALPINE_EDITION=${ALPINE_EDITION} \
    BASE_VERSION=${BASE_VERSION} \
    UNBOUND_BUILD=${UNBOUND_BUILD} \
    UNBOUND_REVISION=${UNBOUND_REVISION}
)

echo "${DOCKERFILE}" > ./Dockerfile

docker system prune -f
echo "Done."
