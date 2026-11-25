# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [4.0.3] - 2026-11-25

### Changed

- Base image updated to `bfren/alpine-s6` 7.0.3, which rebuilds BusyBox, figlet and Nushell without changing
  their versions - see the [Alpine + S6 changelog](https://github.com/bfren/docker-alpine-s6/blob/main/CHANGELOG.md).
- Unbound 1.26.2 is rebuilt (build `261125`) without changing its version - see the
  [release notes](https://github.com/bfren/unbound/releases/tag/v261125).

### Fixed

- README: an example of adding your own Unbound settings.
- The Pi-hole compose examples use Pi-hole v6's variables - `PIHOLE_DNS_` and `WEBPASSWORD` were ignored, so Pi-hole did
  not use Unbound and had no admin password. The `/etc/dnsmasq.d` volume, which Pi-hole v6 doesn't read, is removed, and
  Docker Compose now refuses to start until `PIHOLE_ADMIN_PASSWORD` is set, because Pi-hole v6 turns the login off when
  it is empty.
- `docker-compose-with-proxy.yml` uses [Caddy Proxy](https://github.com/bfren/docker-caddy-proxy) instead of the
  replaced nginx-proxy, and the backup Unbound is pinned to 4.0.2 instead of 3.1.10.
- `docker-compose-pi-hole-default.yml` and `docker-compose-unbound-default.yml` could not be parsed - they are repaired
  and updated in the same way, and the README now says what each one is for.
- The compose examples use the Quay.io image, with the `4.0` tag instead of `latest`, and set `BF_TZ` as well as `TZ`.

## [4.0.2] - 2026-11-10

### Changed

- Base image updated to `bfren/alpine-s6` 7.0.2, which updates Nushell to 0.117.0 (your own Nushell scripts may
  need changes), keeps the container starting when `BF_TZ` cannot be set, and no longer hides `CURRENT_FILE` and
  `FILE_PWD` from services - see the
  [Alpine + S6 changelog](https://github.com/bfren/docker-alpine-s6/blob/main/CHANGELOG.md).

## [4.0.1] - 2026-11-06

### Changed

- Base image updated to `bfren/alpine-s6` 7.0.1, which moves to Alpine 3.24.4 (with security fixes) and rebuilds
  BusyBox, figlet and Nushell - see the
  [Alpine + S6 changelog](https://github.com/bfren/docker-alpine-s6/blob/main/CHANGELOG.md).
- Unbound 1.26.2 is rebuilt (build `261106.3`) on Alpine 3.24.4 - see the
  [release](https://github.com/bfren/unbound/releases/tag/v261106.3).

## [4.0.0] - 2026-11-05

### Changed

- **Breaking:** base image updated to `bfren/alpine-s6` 7.0.0 - see the
  [Alpine + S6 changelog](https://github.com/bfren/docker-alpine-s6/blob/main/CHANGELOG.md).
  `bf env set` must now run as root.
- Images are built and published by the shared `bfren/docker` build workflow (`build.yml`), replacing the separate
  `dev.yml` and `publish.yml` workflows.

[4.0.3]: https://github.com/bfren/docker-unbound/compare/v4.0.2...v4.0.3
[4.0.2]: https://github.com/bfren/docker-unbound/compare/v4.0.1...v4.0.2
[4.0.1]: https://github.com/bfren/docker-unbound/compare/v4.0.0...v4.0.1
[4.0.0]: https://github.com/bfren/docker-unbound/compare/v3.2.1...v4.0.0
