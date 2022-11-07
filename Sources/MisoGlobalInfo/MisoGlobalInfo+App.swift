//
//  MisoGlobalInfo+App.swift
//  MisoGlobalInfo
//
//  Created by Michel Donais on 2019-11-25.
//  Copyright © 2019-2020 Misoservices Inc. All rights reserved.
//  [BSL-1.0] This package is Licensed under the Boost Software License - Version 1.0
//

import Foundation

#if canImport(AppKit)
import AppKit
#endif

public extension GlobalInfo {
    struct App {
        public static var displayName: String? {
            Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ??
                Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
        }
        
        public static var copyright: String? {
            Bundle.main.object(forInfoDictionaryKey: "NSHumanReadableCopyright") as? String
        }

        public static var bundleIdentifier: String? {
            Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as? String
        }

        public static var bundleShortVersion: String? {
            Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        }

        public static var bundleVersion: String? {
            Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
        }

        public static var bundleVersionAsInt: Int {
            let data = self.bundleVersion
            let str = data ?? "0"
            return Int(str) ?? 0
        }
        
        public static var appStoreReceiptURL: URL? {
            Bundle.main.appStoreReceiptURL
        }
        
        public static var appStoreReceipt: Data? {
            guard let appStoreReceiptURL = Self.appStoreReceiptURL else {
                return nil
            }
            return try? Data(contentsOf: appStoreReceiptURL)
        }

        public static var isiOSOnMac: Bool {
            guard #available(iOS 14.0, macOS 11.0, watchOS 7.0, tvOS 14.0, *) else {
                return false
            }
            return ProcessInfo.processInfo.isiOSAppOnMac
        }

        public static var isMacCatalyst: Bool {
            guard #available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 99.99, *) else {
                return false
            }
            return ProcessInfo.processInfo.isMacCatalystApp
        }

        public static var isMacAppleSiliconNativeCode: Bool {
            #if !os(macOS) || targetEnvironment(macCatalyst)
                return false
            #else
                guard #available(macOS 11.0, *) else {
                    return false
                }
                let current = NSRunningApplication.current
                return current.executableArchitecture == NSBundleExecutableArchitectureARM64
            #endif
        }

        public static var isPreview: Bool {
            ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
        }

        public static var isRunningTests: Bool {
            ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
        }
    }
}
