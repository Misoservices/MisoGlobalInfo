//
//  MisoGlobalInfo+OS.swift
//  MisoGlobalInfo
//
//  Created by Michel Donais on 2020-02-25.
//  Copyright © 2019-2023 Misoservices Inc. All rights reserved.
//  [BSL-1.0] This package is Licensed under the Boost Software License - Version 1.0
//

import Foundation

#if os(watchOS)
import WatchKit
#elseif os(macOS)
import IOKit
#else
import UIKit
#endif

public extension GlobalInfo {
    struct OS {
        public static var localizedVersion: String {
            ProcessInfo.processInfo.operatingSystemVersionString
        }

        public static let majorVersion: Int = {
            #if os(macOS)
            return ProcessInfo.processInfo.operatingSystemVersion.majorVersion
            #else

            #if os(watchOS)
            let components = WKInterfaceDevice.current().systemVersion.components(separatedBy: ".")
            #else
            let components = UIDevice.current.systemVersion.components(separatedBy: ".")
            #endif
            guard components.count > 0 else {
                return 0
            }
            return Int(components[0]) ?? 0
            #endif
        }()

        public static let minorVersion: Int = {
            #if os(macOS)
            return ProcessInfo.processInfo.operatingSystemVersion.minorVersion
            #else

            #if os(watchOS)
            let components = WKInterfaceDevice.current().systemVersion.components(separatedBy: ".")
            #else
            let components = UIDevice.current.systemVersion.components(separatedBy: ".")
            #endif
            guard components.count > 1 else {
                return 0
            }
            return Int(components[1]) ?? 0
            #endif
        }()

        public static let patchVersion: Int? = {
            #if os(macOS)
            let patch = ProcessInfo.processInfo.operatingSystemVersion.patchVersion
            return patch > 0 ? patch : nil
            #else

            #if os(watchOS)
            let components = WKInterfaceDevice.current().systemVersion.components(separatedBy: ".")
            #else
            let components = UIDevice.current.systemVersion.components(separatedBy: ".")
            #endif
            guard components.count > 2 else {
                return nil
            }
            return Int(components[2])
            #endif
        }()

        #if os(macOS)
        private static func macUuid() -> Data? {
            // https://developer.apple.com/library/archive/releasenotes/General/ValidateAppStoreReceipt/Chapters/ValidateLocally.html
            guard let ethServiceMatching = IOServiceMatching("IOEthernetInterface") as NSMutableDictionary? else {
                return nil
            }
            ethServiceMatching["IOPropertyMatch"] = [ "IOPrimaryInterface" : true ]

            var iterator: io_iterator_t = IO_OBJECT_NULL
            guard IOServiceGetMatchingServices(kIOMasterPortDefault,
                                               ethServiceMatching,
                                               &iterator) == KERN_SUCCESS else {
                return nil as Data?
            }

            var result: Data?
            while result == nil,
                  let interface = {
                let next = IOIteratorNext(iterator)
                return next == IO_OBJECT_NULL ? nil : next
            }() {
                var parentService: io_object_t = IO_OBJECT_NULL
                if IORegistryEntryGetParentEntry(interface, kIOServicePlane, &parentService) == KERN_SUCCESS {
                    if let retrievedMacAddress = IORegistryEntryCreateCFProperty(parentService, "IOMACAddress" as CFString, kCFAllocatorDefault, 0) {
                        result = (retrievedMacAddress.takeRetainedValue() as! CFData) as Data
                    }
                    IOObjectRelease(parentService)
                }
                IOObjectRelease(interface)
            }
            IOObjectRelease(iterator)
            return result as Data?
        }
        #endif

        // From Apple documentation:
        // When implementing a system for serving advertisements, use the value in the
        // advertisingIdentifier property of the ASIdentifierManager class instead of this
        // property. Use of that property requires you to follow the guidelines set forth
        // in the class discussion for the proper use of that identifier. For more
        // information, see ASIdentifierManager.
        @available(watchOS 6.2, *)
        public static let uuid: Data? = {
            #if os(macOS)
            return macUuid()
            #else
            
            // iOS / watchOS
            #if os(watchOS)
            guard let uuid = WKInterfaceDevice.current().identifierForVendor?.uuid else {
                return nil
            }
            #else
            guard let uuid = UIDevice.current.identifierForVendor?.uuid else {
                return nil
            }
            #endif
            
            let addr = withUnsafePointer(to: uuid) { (p) -> UnsafeRawPointer in
                UnsafeRawPointer(p)
            }
            return Data(bytes: addr, count: 16) as Data?

            #endif
        }()

    }
}
