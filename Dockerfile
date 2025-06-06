FROM ghcr.io/bfren/alpine-s6:alpine3.22-5.6.2

LABEL org.opencontainers.image.source="https://github.com/bfren/docker-unbound"

ARG BF_IMAGE
ARG BF_PUBLISHING
ARG BF_VERSION

EXPOSE 53/tcp
EXPOSE 53/udp

COPY ./overlay /

RUN bf-install
