# Unbound compiled for Alpine (see https://github.com/bfren/unbound)
FROM quay.io/bfren-bin/unbound:1.26.2-261021 AS unbound

FROM quay.io/bfren/alpine-s6:alpine3.24-7.0.0-dev

LABEL org.opencontainers.image.source="https://github.com/bfren/docker-unbound"

ARG BF_IMAGE
ARG BF_PUBLISHING
ARG BF_VERSION

EXPOSE 53/tcp
EXPOSE 53/udp

ENV \
    # validate answers with DNSSEC, using the root trust anchor - 0 to disable
    BF_UNBOUND_ENABLE_DNSSEC=1

COPY --from=unbound / /
COPY ./overlay /

RUN bf-install
