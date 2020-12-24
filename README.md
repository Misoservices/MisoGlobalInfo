# MisoGlobalInfo

## Swift package to get basic information from the hardware / os / info.plist

Instead of searching everywhere for the most used variables, these are provided here.

### Main app's bundle info

- Application name: `GlobalInfo.App.displayName`
- Copyright: `GlobalInfo.App.copyright`
- Identifier: `GlobalInfo.App.bundleIdentifier`
- Version: `GlobalInfo.App.bundleShortVersion`,  `GlobalInfo.App.bundleVersion`, and `GlobalInfo.App.bundleVersionAsInt`.

### Hardware environment

- Device code name: `GlobalInfo.HW.modelIdentifier`, `GlobalInfo.HW.simulatorModelIdentifier`
- Device family name (iPhone, iPad, ...): `GlobalInfo.HW.family`

### Software environment

- OS version: `GlobalInfo.OS.majorVersion`

### App store receipt validation

- App store receipt retrieval: `GlobalInfo.App.appStoreReceiptURL`,  `GlobalInfo.App.hasAppStoreReceipt` and `GlobalInfo.App.appStoreReceipt`
- identifierForVendor's UUID retrieval (not for advertisements): `GlobalInfo.OS.uuid`

### macOS 11 / iOS 14 Logger support

- Defines the `subsystem` as the `bundleIdentifier` automatically. Simply create your logger with the category: `Logger(category: "SomeCategory")` 

## Colophon

[The official address for this package][0]

[The git / package url][1]

This package is created and maintained by [Misoservices Inc.][2] and is [licensed under the BSL-1.0: Boost Software License - Version 1.0][3].


[0]: https://github.com/Misoservices/MisoGlobalInfo
[1]: https://github.com/Misoservices/MisoGlobalInfo.git
[2]: https://misoservices.com
[3]: https://choosealicense.com/licenses/bsl-1.0/
