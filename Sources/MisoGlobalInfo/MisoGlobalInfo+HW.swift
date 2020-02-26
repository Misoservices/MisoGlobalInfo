//
//  MisoGlobalInfo+HW.swift
//  MisoGlobalInfo
//
//  Created by Michel Donais on 2019-11-25.
//  Copyright © 2019-2020 Misoservices Inc. All rights reserved.
//  [BSL-1.0] This package is Licensed under the Boost Software License - Version 1.0
//

import Foundation

public extension GlobalInfo {
    struct HW {
        public static var modelIdentifier: String? {
            var mib: [CInt] = [CTL_HW, HW_MACHINE]
            var size: Int = 0
            if sysctl(&mib, CUnsignedInt(mib.count), nil, &size, nil, 0) != 0 {
                return nil
            }
            if size < 1 || size > 64 {
                return nil
            }
            var resultPtr = [CChar](repeating: 0, count: size)
            if sysctl(&mib, CUnsignedInt(mib.count), &resultPtr, &size, nil, 0) != 0 {
                return nil
            }
            return String(cString: resultPtr)
        }
        
        public static var simulatorModelIdentifier: String? {
            ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"]
        }

        public enum Family {
            case unknown
            case mac
            case appleTV
            case iPad
            case iPhone
            case iPod
            case watch
        }
        
        public static var family: Family {
            guard var modelIdentifier = Self.modelIdentifier else {
                return .unknown
            }
            
            if modelIdentifier == "x86_64" || modelIdentifier == "i386" {
                if let simulatorModelIdentifier = self.simulatorModelIdentifier {
                    modelIdentifier = simulatorModelIdentifier
                } else {
                    return .mac
                }
            }
            
            if modelIdentifier.starts(with: "AppleTV") {
                return .appleTV
            } else if modelIdentifier.starts(with: "iPad") {
                return .iPad
            } else if modelIdentifier.starts(with: "iPhone") {
                return .iPhone
            } else if modelIdentifier.starts(with: "iPod") {
                return .iPod
            } else if modelIdentifier.starts(with: "Watch") {
                return .watch
            } else if modelIdentifier.contains("Mac") {
                return .mac
            } else {
                return .unknown
            }
        }
    }
}
