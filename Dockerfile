FROM bfren/alpine-s6:alpine3.19-5.1.2

LABEL org.opencontainers.image.source="https://github.com/bfren/docker-unbound"

ARG BF_IMAGE
ARG BF_VERSION

EXPOSE 53/tcp
EXPOSE 53/udp

COPY ./overlay /

RUN bf-install
