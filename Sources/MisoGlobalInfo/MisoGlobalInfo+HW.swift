//
//  MisoGlobalInfo+HW.swift
//  MisoGlobalInfo
//
//  Created by Michel Donais on 2019-11-25.
//  Copyright © 2019-2023 Misoservices Inc. All rights reserved.
//  [BSL-1.0] This package is Licensed under the Boost Software License - Version 1.0
//

import Foundation
import MachO

public extension GlobalInfo {
    struct HW {
        public static let modelIdentifier: String? = {
            var mib: [Int32]
            if #available(iOS 17.0, macOS 14.0, watchOS 10.0, tvOS 17.0, *) {
                mib = [CTL_HW, HW_PRODUCT]
            } else {
                mib = [CTL_HW, HW_MACHINE]
            }
            var size = 0
            guard sysctl(&mib, CUnsignedInt(mib.count), nil, &size, nil, 0) == 0,
                  size > 0 && size <= 64 else {
                return nil
            }
            var resultPtr = [CChar](repeating: 0, count: size)
            guard sysctl(&mib, CUnsignedInt(mib.count), &resultPtr, &size, nil, 0) == 0,
                  size > 0 && size <= resultPtr.count,
                  resultPtr[size - 1] == 0 else {
                return nil
            }
            return String(cString: resultPtr)
        }()

        public static let isSimulator: Bool = {
            #if targetEnvironment(simulator)
            return true
            #else
            return false
            #endif
        }()

        public static let simulatorModelIdentifier: String? = {
            ProcessInfo.processInfo.environment["SIMULATOR_MODEL_IDENTIFIER"]
        }()

        public enum Family {
            case unknown
            case airPods
            case airTag
            case appleTV
            case appleVision
            case homePod
            case mac
            case iPad
            case iPhone
            case iPod
            case watch
        }
        
        public static let family: Family = {
            guard var modelIdentifier = Self.modelIdentifier else {
                return .unknown
            }
            
            if modelIdentifier == "x86_64" || modelIdentifier == "i386" || modelIdentifier == "arm64" {
                if let simulatorModelIdentifier = simulatorModelIdentifier {
                    modelIdentifier = simulatorModelIdentifier
                } else {
                    return .mac
                }
            }
            
            switch modelIdentifier.prefix(4) {
                case "AirP", "iPro": return .airPods
                case "AirT": return .airTag
                case "Appl": return .appleTV
                case "Audi": return .homePod
                case "iPad": return .iPad
                case "iPho": return .iPhone
                case "iPod": return .iPod
                case "Real": return .appleVision
                case "Watc": return .watch
                default:
                    if modelIdentifier.contains("Mac") {
                        return .mac
                    }
                    return .unknown
            }
        }()
    }
}
