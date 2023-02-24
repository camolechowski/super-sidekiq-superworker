# CHANGELOG for `invoca-kafka`

Inspired by [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

Note: this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.2.3] - Unreleased
### Changed
* Cleanup usage of Redis#multi to not use different connections while within the `multi` block.
* Allow support for sidekiq 6.

## [1.2.2] - 2023-02-23
### Changed
* Limit required version of sidekiq, activesupport, and activemodel to >= 5, < 6.
