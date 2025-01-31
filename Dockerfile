FROM ghcr.io/bfren/alpine-s6:alpine3.21-5.5.1

LABEL org.opencontainers.image.source="https://github.com/bfren/docker-unbound"

ARG BF_IMAGE
ARG BF_PUBLISHING
ARG BF_VERSION

EXPOSE 53/tcp
EXPOSE 53/udp

COPY ./overlay /

RUN bf-install
