//
//  MisoGlobalInfo+App.swift
//  MisoGlobalInfo
//
//  Created by Michel Donais on 2019-11-25.
//  Copyright © 2019-2023 Misoservices Inc. All rights reserved.
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

        public static let isRosetta: Bool? = {
            let name = "sysctl.proc_translated"
            var result = Int32(-1)
            var size = 4
            guard sysctlbyname(name, &result, &size, nil, 0) == 0,
                  size == 4,
                  result != -1 else {
                return nil
            }
            return result == 1
        }()

        public static let buildArchitecture: String? = {
            // This list is based on https://github.com/apple/swift
            #if arch(i386)
                return "i386"
            #elseif arch(arm)
                return "ARM"
            #elseif arch(arm64_32)
                return "ARM64 (32bit pointers)"
            #elseif arch(wasm32)
                return "WebAssembly 32"
            #elseif arch(powerpc)
                return "PowerPC"
            #elseif arch(x86_64)
                return "x86-64"
            #elseif arch(arm64)
                return "ARM64"
            #elseif arch(powerpc64)
                return "PowerPC 64"
            #elseif arch(powerpc64le)
                return "PowerPC 64le"
            #elseif arch(s390x)
                return "System/390 64"
//            #elseif arch(riscv64)
//                return "RISC-V 64"
            #else
                return nil
            #endif
        }()

        public static var isPreview: Bool {
            ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
        }

        public static var isRunningTests: Bool {
            ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
        }

        public static var _argumentsOverride: [String]? = nil

        public static func hasArgument(_ argument: String) -> Bool {
            var arguments = _argumentsOverride ?? ProcessInfo.processInfo.arguments
            _ = arguments.removeFirst()
            return arguments.contains(argument)
        }

        public static func argumentValue(_ argument: String) -> String? {
            let arguments = _argumentsOverride ?? ProcessInfo.processInfo.arguments
            for index in 1..<arguments.count - 1 where arguments[index] == argument {
                return arguments[index + 1]
            }
            return nil
        }

        public static var processPathName: String? {
            let arguments = _argumentsOverride ?? ProcessInfo.processInfo.arguments
            return arguments.first
        }
    }
}
