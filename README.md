# Unbound

![GitHub release (latest by date)](https://img.shields.io/github/v/release/bfren/docker-unbound) ![Docker Pulls](https://img.shields.io/endpoint?url=https%3A%2F%2Fbfren.dev%2Fdocker%2Fpulls%2Funbound) ![Docker Image Size](https://img.shields.io/endpoint?url=https%3A%2F%2Fbfren.dev%2Fdocker%2Fsize%2Funbound) ![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/bfren/docker-unbound/build.yml?branch=main)

[Docker Hub](https://hub.docker.com/r/bfren/unbound) - [Quay.io](https://quay.io/repository/bfren/unbound) - [bfren ecosystem](https://github.com/bfren/docker)

## Introduction

[Unbound](https://nlnetlabs.nl/projects/unbound/about/) is a recursive DNS resolver: instead of sending your lookups to a public DNS provider, it asks the root servers and each domain's own name servers directly, and can check the answers with DNSSEC.

It is built on [Alpine + S6](https://github.com/bfren/docker-alpine-s6), with the latest Unbound release [compiled for Alpine](https://github.com/bfren/unbound) (Alpine's own package stays on the version each Alpine release shipped with), and is configured with environment variables. It works well as the upstream resolver for [Pi-hole](https://pi-hole.net) - see the example compose files in this repository.

## Quickstart

```yaml
services:
  unbound:
    image: quay.io/bfren/unbound:4.0
    restart: unless-stopped
    ports:
      - "127.0.0.1:53:53/tcp"
      - "127.0.0.1:53:53/udp"
```

Run `docker compose up -d`, then test it from the host:

```sh
dig example.com @127.0.0.1
```

`docker-compose.yml` in this repository runs Pi-hole with two Unbound containers, and `docker-compose-with-proxy.yml` puts Pi-hole's admin site behind a proxy. Copy `.env` alongside them and change the values.

## Features

* 🔎 Recursive resolver - no third-party DNS provider sees your lookups
* 🔐 DNSSEC validation, with the root trust anchor kept up to date
* ⚙️ About 50 Unbound settings available as environment variables
* 🛡️ Optional protection against DNS rebinding (private addresses)
* ✅ Configuration checked before Unbound starts
* 🩺 Health check that resolves a real domain
* 🧪 Built-in tests

## Tags

Images are published to Docker Hub (`bfren/unbound`) and Quay.io (`quay.io/bfren/unbound`) for `linux/amd64`, `linux/arm/v7` and `linux/arm64`, with Unbound 1.26.2 on Alpine 3.24.

| Tag                      | Example             | Use when                                   |
| ------------------------ | ------------------- | ------------------------------------------ |
| `latest`                 |                     | You always want the newest image           |
| `MAJOR`                  | `4`                 | You want updates, but not breaking changes |
| `MINOR`                  | `4.0`               | You want fixes only - **recommended**      |
| `VERSION`                | `4.0.0`             | You want to pin this image exactly         |
| `unboundX`, `unboundX.Y` | `unbound1.26`       | You want an Unbound version                |
| `unboundX.Y.Z`           | `unbound1.26.2`     | You want an exact Unbound release          |
| `unboundX.Y-VERSION`     | `unbound1.26-4.0.0` | You want to pin both                       |

## Configuration

### Ports

| Port     | Purpose                              |
| -------- | ------------------------------------ |
| `53/udp` | DNS                                  |
| `53/tcp` | DNS (large answers and DNS over TCP) |

### Environment Variables

| Variable                            | Values   | Description                                                                                             | Default |
| ----------------------------------- | -------- | ------------------------------------------------------------------------------------------------------- | ------- |
| `BF_UNBOUND_ENABLE_DNSSEC`          | `0`, `1` | Validate answers with DNSSEC, using the root trust anchor (downloaded and kept up to date).             | `1`     |
| `BF_UNBOUND_PRIVATE_ADDRESS_ENABLE` | `0`, `1` | Remove private addresses (e.g. `192.168.0.0/16`) from public answers, to protect against DNS rebinding. | `0`     |

Each of these sets the Unbound option of the same name - see the [unbound.conf manual](https://unbound.docs.nlnetlabs.nl/en/latest/manpages/unbound.conf.html) for what they do:

| Variable                               | Unbound option              | Default    |
| -------------------------------------- | --------------------------- | ---------- |
| `BF_UNBOUND_VERBOSITY`                 | `verbosity`                 | `1`        |
| `BF_UNBOUND_STATISTICS_INTERVAL`       | `statistics-interval`       | `0`        |
| `BF_UNBOUND_SHM_ENABLE`                | `shm-enable`                | `no`       |
| `BF_UNBOUND_SHM_KEY`                   | `shm-key`                   | `11777`    |
| `BF_UNBOUND_STATISTICS_CUMULATIVE`     | `statistics-cumulative`     | `no`       |
| `BF_UNBOUND_EXTENDED_STATISTICS`       | `extended-statistics`       | `no`       |
| `BF_UNBOUND_STATISTICS_INHIBIT_ZERO`   | `statistics-inhibit-zero`   | `yes`      |
| `BF_UNBOUND_NUM_THREADS`               | `num-threads`               | `1`        |
| `BF_UNBOUND_INTERFACE_AUTOMATIC`       | `interface-automatic`       | `yes`      |
| `BF_UNBOUND_PREFER_IP6`                | `prefer-ip6`                | `no`       |
| `BF_UNBOUND_PREFER_IP4`                | `prefer-ip4`                | `no`       |
| `BF_UNBOUND_OUTGOING_NUM_TCP`          | `outgoing-num-tcp`          | `10`       |
| `BF_UNBOUND_INCOMING_NUM_TCP`          | `incoming-num-tcp`          | `10`       |
| `BF_UNBOUND_SO_RCVBUF`                 | `so-rcvbuf`                 | `0`        |
| `BF_UNBOUND_SO_SNDBUF`                 | `so-sndbuf`                 | `0`        |
| `BF_UNBOUND_EDNS_BUFFER_SIZE`          | `edns-buffer-size`          | `1232`     |
| `BF_UNBOUND_MAX_UDP_SIZE`              | `max-udp-size`              | `1232`     |
| `BF_UNBOUND_ITER_SCRUB_PROMISCUOUS`    | `iter-scrub-promiscuous`    | `yes`      |
| `BF_UNBOUND_DISCARD_TIMEOUT`           | `discard-timeout`           | `1900`     |
| `BF_UNBOUND_WAIT_LIMIT`                | `wait-limit`                | `1000`     |
| `BF_UNBOUND_WAIT_LIMIT_COOKIE`         | `wait-limit-cookie`         | `10000`    |
| `BF_UNBOUND_CACHE_MIN_TTL`             | `cache-min-ttl`             | `0`        |
| `BF_UNBOUND_CACHE_MAX_TTL`             | `cache-max-ttl`             | `86400`    |
| `BF_UNBOUND_CACHE_MIN_NEGATIVE_TTL`    | `cache-min-negative-ttl`    | `0`        |
| `BF_UNBOUND_DO_IP4`                    | `do-ip4`                    | `yes`      |
| `BF_UNBOUND_DO_IP6`                    | `do-ip6`                    | `yes`      |
| `BF_UNBOUND_DO_UDP`                    | `do-udp`                    | `yes`      |
| `BF_UNBOUND_DO_TCP`                    | `do-tcp`                    | `yes`      |
| `BF_UNBOUND_LOG_SERVFAIL`              | `log-servfail`              | `no`       |
| `BF_UNBOUND_HIDE_IDENTITY`             | `hide-identity`             | `yes`      |
| `BF_UNBOUND_HIDE_VERSION`              | `hide-version`              | `yes`      |
| `BF_UNBOUND_HIDE_HTTP_USER_AGENT`      | `hide-http-user-agent`      | `no`       |
| `BF_UNBOUND_HARDEN_SHORT_BUFSIZE`      | `harden-short-bufsize`      | `yes`      |
| `BF_UNBOUND_HARDEN_LARGE_QUERIES`      | `harden-large-queries`      | `no`       |
| `BF_UNBOUND_HARDEN_GLUE`               | `harden-glue`               | `yes`      |
| `BF_UNBOUND_HARDEN_UNVERIFIED_GLUE`    | `harden-unverified-glue`    | `yes`      |
| `BF_UNBOUND_HARDEN_DNSSEC_STRIPPED`    | `harden-dnssec-stripped`    | `yes`      |
| `BF_UNBOUND_HARDEN_BELOW_NXDOMAIN`     | `harden-below-nxdomain`     | `yes`      |
| `BF_UNBOUND_HARDEN_ALGO_DOWNGRADE`     | `harden-algo-downgrade`     | `no`       |
| `BF_UNBOUND_HARDEN_UNKNOWN_ADDITIONAL` | `harden-unknown-additional` | `no`       |
| `BF_UNBOUND_QNAME_MINIMISATION`        | `qname-minimisation`        | `yes`      |
| `BF_UNBOUND_AGGRESSIVE_NSEC`           | `aggressive-nsec`           | `yes`      |
| `BF_UNBOUND_USE_CAPS_FOR_ID`           | `use-caps-for-id`           | `no`       |
| `BF_UNBOUND_UNWANTED_REPLY_THRESHOLD`  | `unwanted-reply-threshold`  | `10000000` |
| `BF_UNBOUND_DO_NOT_QUERY_LOCALHOST`    | `do-not-query-localhost`    | `yes`      |
| `BF_UNBOUND_PREFETCH`                  | `prefetch`                  | `no`       |
| `BF_UNBOUND_PREFETCH_KEY`              | `prefetch-key`              | `no`       |
| `BF_UNBOUND_DENY_ANY`                  | `deny-any`                  | `yes`      |
| `BF_UNBOUND_MINIMAL_RESPONSES`         | `minimal-responses`         | `yes`      |
| `BF_UNBOUND_SERVE_EXPIRED`             | `serve-expired`             | `no`       |
| `BF_UNBOUND_VAL_LOG_LEVEL`             | `val-log-level`             | `1`        |
| `BF_UNBOUND_ANSWER_COOKIE`             | `answer-cookie`             | `no`       |
| `BF_UNBOUND_EDE`                       | `ede`                       | `yes`      |
| `BF_UNBOUND_EDE_SERVE_EXPIRED`         | `ede-serve-expired`         | `yes`      |

See [Alpine + S6](https://github.com/bfren/docker-alpine-s6#environment-variables) for `BF_DEBUG`, `BF_TZ` and the other base image variables.

## How It Works

On every start `/etc/unbound/unbound.conf` is generated from the environment variables. Unbound listens on port 53 on every IPv4 address in the container, and answers anyone who can reach it - so only publish the port where you mean to.

Before Unbound starts:

* unless `BF_UNBOUND_ENABLE_DNSSEC=0`, `unbound-anchor` downloads or updates the root trust anchor (`/etc/unbound/root.key`)
* `unbound-checkconf` checks the configuration - if it is invalid, Unbound doesn't start, and the error is in the log

Then Unbound runs under S6 as the `unbound` user. The container stops if it crashes. The root hints (the addresses of the root servers) are downloaded when the image is built.

The health check (every 30 seconds) looks up `cloudflare.com` using Unbound itself, so it fails if Unbound can't reach the internet.

## Testing

```sh
./test.nu   # builds the image and runs /test
./run.sh    # builds the image and opens a shell, with DNSSEC on and Unbound on 127.0.0.1:5353/udp
```

`/test` runs this image's tests alongside the base images' tests: the generated `unbound.conf` (with and without DNSSEC, defaults, settings and private addresses), the paths used, and the installed Unbound version.

## Troubleshooting

### The container keeps restarting

Unbound's configuration check failed, or the trust anchor couldn't be downloaded. Check `docker logs <container>` - a mistyped value in a `BF_UNBOUND_*` variable is the usual cause.

### Lookups fail with `SERVFAIL`

With DNSSEC on, `SERVFAIL` usually means an answer failed validation - often because the container's clock is wrong, or the domain's DNSSEC is broken. Try the lookup with `+cd` (checking disabled), e.g. `dig example.com @127.0.0.1 +cd`, to see which, or set `BF_UNBOUND_LOG_SERVFAIL=yes` to log the reason.

### Port 53 is already in use on the host

On many Linux systems `systemd-resolved` uses port 53. Publish Unbound on a specific address (e.g. `"192.168.1.10:53:53/udp"`), or use it only from other containers.

## FAQs

### Why run two Unbound containers in the example?

So DNS keeps working while one restarts or updates. Pin the second one to an older image version (`UNBOUND_PIN` in `.env`) and update it separately.

### Can I add my own Unbound settings?

`unbound.conf` includes every `*.conf` file in `/etc/unbound/unbound.conf.d`, so mount your own files there.

## Licence

> [MIT](https://mit.bfren.dev/2023)

## Copyright

> Unbound is (c) 2007, NLnet Labs and licensed under [BSD-3](https://github.com/NLnetLabs/unbound/blob/master/LICENSE).
>
> Copyright (c) 2023-2026 [bfren](https://bfren.dev) (unless otherwise stated)
