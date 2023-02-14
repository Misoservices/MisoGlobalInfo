//
//  MisoGlobalInfo.swift
//  MisoGlobalInfo
//
//  Created by Michel Donais on 2020-12-24.
//  Copyright © 2019-2023 Misoservices Inc. All rights reserved.
//  [BSL-1.0] This package is Licensed under the Boost Software License - Version 1.0
//


import os
import Foundation

@available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *)
public extension Logger {
    init(category: String) {
        self.init(subsystem: GlobalInfo.App.bundleIdentifier ?? "No bundleIdentifier",
                  category: category)
    }
    init(file: String /* = #file */) {
        self.init(category: URL(string: file)?.deletingPathExtension().lastPathComponent ?? "No filename")
    }

    static func logAppContext() {
        let logger = Logger(category: "GlobalInfo")
        let patchVersionString: String?
        if let patchVersion = GlobalInfo.OS.patchVersion {
            patchVersionString = ".\(patchVersion)"
        } else {
            patchVersionString = nil
        }
        logger.info("""
            \(GlobalInfo.App.displayName ?? GlobalInfo.App.processPathName ?? "[no process info]", privacy: .public) \
            \(GlobalInfo.App.bundleShortVersion ?? "[no version]", privacy: .public) \
            (\(GlobalInfo.App.bundleVersionAsInt), privacy: .public) \
            (\(GlobalInfo.App.buildArchitecture ?? "[Unknown architecture], privacy: .public") \
            \(GlobalInfo.App.isRunningTests ? ", XCTest" : "", privacy: .public) \
            \(GlobalInfo.App.isPreview ? ", Preview" : "", privacy: .public) \
            \(GlobalInfo.App.isMacCatalyst ? ", Mac Catalyst" : "", privacy: .public) \
            \(GlobalInfo.App.isRosetta ?? false) ? ", Rosetta" : "", privacy: .public)) \
            on \(GlobalInfo.HW.isSimulator ? "Simulated " : "", privacy: .public)\
            \(GlobalInfo.HW.modelIdentifier ?? "[Unknown model]", privacy: .public)
            (\(GlobalInfo.HW.architecture ?? "Unknown architecture", privacy: .public)) \
            running \(GlobalInfo.OS.localizedVersion, privacy: .public) \
            [\(GlobalInfo.OS.majorVersion, privacy: .public)\
            .\(GlobalInfo.OS.minorVersion, privacy: .public)\
            .\(patchVersionString ?? "", privacy: .public)]
        """)
    }

    private static var _logAppContextDone = false
    static func logAppContextOnce() {
        guard !_logAppContextDone else {
            return
        }
        _logAppContextDone = true
        logAppContext()
    }
}
