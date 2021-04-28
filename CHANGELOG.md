# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

Please check our [developers guide](https://gitlab.com/tokend/developers-guide)
for further information about branching and tagging conventions.

## [Unreleased]

### Added
- `KeyServerLoginService` to have ability to change `walletKDF ` and `walletData` source

### Deprecated
- `KeyServerApi+Login` methods (use `KeyServerLoginService` instead)

## [3.3.2] 2021-04-28

### Added
- Separate error for TFA cancelled so that user can recognize it and handle in a proper way
- `Account-Id` signature header

### Fixed
- `LoadAllResourcesController` bug with not reloading resources after error occured

