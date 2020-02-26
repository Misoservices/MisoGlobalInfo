//
//  MisoGlobalInfo+App.swift
//  MisoGlobalInfo
//
//  Created by Michel Donais on 2019-11-25.
//  Copyright © 2019-2020 Misoservices Inc. All rights reserved.
//  [BSL-1.0] This package is Licensed under the Boost Software License - Version 1.0
//

import Foundation

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
        
        public static var hasAppStoreReceipt: Bool {
            if let appStoreReceiptURL = Self.appStoreReceiptURL,
                let isReachable = try? appStoreReceiptURL.checkResourceIsReachable() {
                return isReachable
            }
            return false
        }
        
        public static var appStoreReceipt: Data? {
            if Self.hasAppStoreReceipt,
                let appStoreReceiptURL = Self.appStoreReceiptURL {
                return try? Data(contentsOf: appStoreReceiptURL)
            }
            return nil
        }
    }
}
