//
//  MisoGlobalInfo.swift
//  MisoGlobalInfo
//
//  Created by Michel Donais on 2020-12-24.
//  Copyright © 2019-2020 Misoservices Inc. All rights reserved.
//  [BSL-1.0] This package is Licensed under the Boost Software License - Version 1.0
//


import os

@available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *)
public extension Logger {
    init(category: String) {
        self.init(subsystem: GlobalInfo.App.bundleIdentifier ?? "No bundleIdentifier",
                  category: category)
    }
}
