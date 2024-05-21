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
        public enum Family: CustomStringConvertible {
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
            case virtualMachine
            case watch

            public var description: String {
                switch self {
                    case .unknown: return "Unknown"
                    case .airPods: return "AirPods"
                    case .airTag: return "AirTag"
                    case .appleTV: return "AppleTV"
                    case .appleVision: return "AppleVision"
                    case .homePod: return "HomePod"
                    case .mac: return "Mac"
                    case .iPad: return "iPad"
                    case .iPhone: return "iPhone"
                    case .iPod: return "iPod"
                    case .virtualMachine: return "Virtual Machine"
                    case .watch: return "AppleWatch"
                }
            }

            init?(from model: String?) {
                guard let model = model else {
                    return nil
                }
                switch model.prefix(4) {
                    case "AirP", "iPro": self = .airPods
                    case "AirT": self = .airTag
                    case "Appl": self = .appleTV
                    case "Audi": self = .homePod
                    case "iPad": self = .iPad
                    case "iPho": self = .iPhone
                    case "iPod": self = .iPod
                    case "MacV": self = .virtualMachine
                    case "Real": self = .appleVision
                    case "Watc": self = .watch

                    case "x86_", "i386", "arm6": self = .mac
                    default:
                        if model.contains("Mac") {
                            self = .mac
                        } else {
                            self = .unknown
                        }
                }
            }
        }

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

        public static let systemFamily: Family? = {
            Family(from: modelIdentifier)
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
        public static let simulatorFamily: Family? = {
            Family(from: simulatorModelIdentifier)
        }()

        public static let family: Family = {
            if isSimulator,
               let simulatorFamily = simulatorFamily {
                return simulatorFamily
            }
            if let systemFamily = systemFamily {
                return systemFamily
            }
            return .unknown
        }()
    }
}
