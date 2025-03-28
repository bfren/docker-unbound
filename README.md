# Docker Unbound

![GitHub release (latest by date)](https://img.shields.io/github/v/release/bfren/docker-unbound) ![Docker Pulls](https://img.shields.io/endpoint?url=https%3A%2F%2Fbfren.dev%2Fdocker%2Fpulls%2Funbound) ![Docker Image Size](https://img.shields.io/endpoint?url=https%3A%2F%2Fbfren.dev%2Fdocker%2Fsize%2Funbound) ![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/bfren/docker-unbound/dev.yml?branch=main)

[Docker Repository](https://hub.docker.com/r/bfren/unbound) - [bfren ecosystem](https://github.com/bfren/docker)

Comes with [Unbound](https://nlnetlabs.nl/projects/unbound/about/) pre-installed.

See sample `.env` and `docker-compose.yml` files for usage (plus `-with-proxy` files).  Or run as:

```bash
docker run \
    --name=unbound \
    --detach=true \
    --env UNBOUND_ENABLE_DNSSEC=1 \
    --publish=53:53/tcp \
    --publish=53:53/udp \
    --restart=unless-stopped \
    bfren/unbound:latest
```

## Contents

* [Ports](#ports)
* [Environment Variables](#environment-variables)
* [Helper Functions](#helper-functions)
* [Licence / Copyright](#licence)

## Ports

* 53

## Environment Variables

You can override various values in Unbound's configuration using environment variables - see /overlay/etc/bf/templates/unbound.conf.esh for details.

## Helper Functions

Run `nu`, type `bf-unbound` and hit `tab` to see a list of helper functions.

## Licence

> [MIT](https://mit.bfren.dev/2023)

## Copyright

> Unbound is (c) 2007, NLnet Labs and licensed under [BSD-3](https://github.com/NLnetLabs/unbound/blob/master/LICENSE).
>
> Copyright (c) 2023-2025 [bfren](https://bfren.dev) (unless otherwise stated)
