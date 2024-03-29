# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

Please check our [developers guide](https://gitlab.com/tokend/developers-guide)
for further information about branching and tagging conventions.

## [Unreleased]

### Added
- `FeesApiV3` to `APIv3`

## [4.0.4] 2021-08-04

### Fixed
- `ApiConfigurationProviderProtocol` usage instead of `ApiConfiguration`

## [4.0.3] 2021-08-04

### Added
 - `ApiConfigurationProviderProtocol` to `API`s

## [4.0.2] 2021-07-29

### Deprecated
 - `BlobResponse.BlobContent`

## [4.0.1] 2021-06-09

### Fixed
 - Generation of dates parsing
 - Generation of attributes of `Resource` types

## [4.0.0] 2021-06-04

### Removed
- All deprecated APIs and methods. To migrate to version `4.0.0` first install version `3.4.0` and follow suggestions.

## [3.4.0] 2021-06-04

### Refactored
- `APIv1`

### Deprecated
- `APIv1`

## [3.3.3] 2021-05-05

### Added
- `KeyServerLoginService` to have ability to change `walletKDF ` and `walletData` source
- `custom` `RequestIdentitiesFilter`

### Deprecated
- `KeyServerApi+Login` methods (use `KeyServerLoginService` instead)

## [3.3.2] 2021-04-28

### Added
- Separate error for TFA cancelled so that user can recognize it and handle in a proper way
- `Account-Id` signature header

### Fixed
- `LoadAllResourcesController` bug with not reloading resources after error occured

