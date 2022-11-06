# MisoGlobalInfo

## Swift package to get basic information from the hardware / os / info.plist

Instead of searching everywhere for the most used variables, these are provided here.

### Main app's bundle info

- Application name: `GlobalInfo.App.displayName`
- Copyright: `GlobalInfo.App.copyright`
- Identifier: `GlobalInfo.App.bundleIdentifier`
- Version: `GlobalInfo.App.bundleShortVersion`,  `GlobalInfo.App.bundleVersion`, and `GlobalInfo.App.bundleVersionAsInt`.
- Environment: `GlobalInfo.App.isiOSOnMac`, `GlobalInfo.App.isMacCatalyst`, `GlobalInfo.App.isMacAppleSiliconNativeCode`.

### Hardware environment

- Device code name: `GlobalInfo.HW.modelIdentifier`, `GlobalInfo.HW.simulatorModelIdentifier`
- Device family name (iPhone, iPad, ...): `GlobalInfo.HW.family`

### Software environment

- OS version: `GlobalInfo.OS.majorVersion`

### App store receipt validation

- App store receipt retrieval: `GlobalInfo.App.appStoreReceiptURL` and `GlobalInfo.App.appStoreReceipt`
- identifierForVendor's UUID retrieval (not for advertisements): `GlobalInfo.OS.uuid`

### macOS 11 / iOS 14 Logger support

- Defines the `subsystem` as the `bundleIdentifier` automatically. Simply create your logger with the category: `Logger(category: "SomeCategory")`
- Defines the `subsystem` as well as the `category` automatically from the file name: `Logger(file: #file)`

## Version History

### 1.0.3

- OSS-72 Added `Logger(file: #file)` simplification

### 1.0.2

- Added version history.
- OSS-69 Removed `GlobalInfo.App.hasAppStoreReceipt` as it breaks Apple suggestion for file retrieval's good practice. `Data` will return `nil` if invalid.
- OSS-70 Added macOS app environment information (running an iOS app on Mac, running on Mac Catalyst, running an Apple Silicon native version).

### 1.0.1

- OSS-68 Added simple `Logger` for macOS 11 / IOS 14
- OSS-67 Improved `sysctl` calls for macOS

### 1.0.0

- Initial Revision

## Colophon

[The official address for this package][0]

[The git / package url][1]

This package is created and maintained by [Misoservices Inc.][2] and is [licensed under the BSL-1.0: Boost Software License - Version 1.0][3].


[0]: https://github.com/Misoservices/MisoGlobalInfo
[1]: https://github.com/Misoservices/MisoGlobalInfo.git
[2]: https://misoservices.com
[3]: https://choosealicense.com/licenses/bsl-1.0/
