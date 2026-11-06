# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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

[4.0.1]: https://github.com/bfren/docker-unbound/compare/v4.0.0...v4.0.1
[4.0.0]: https://github.com/bfren/docker-unbound/compare/v3.2.1...v4.0.0
