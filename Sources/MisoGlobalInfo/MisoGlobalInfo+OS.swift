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

        // From Apple documentation:
        // When implementing a system for serving advertisements, use the value in the
        // advertisingIdentifier property of the ASIdentifierManager class instead of this
        // property. Use of that property requires you to follow the guidelines set forth
        // in the class discussion for the proper use of that identifier. For more
        // information, see ASIdentifierManager.
        @available(watchOS 6.2, *)
        public static let uuid: Data? = {
            #if os(macOS)
            
            // https://developer.apple.com/library/archive/releasenotes/General/ValidateAppStoreReceipt/Chapters/ValidateLocally.html
            var masterPort: mach_port_t = UInt32(MACH_PORT_NULL)
            var iterator: io_iterator_t = UInt32(MACH_PORT_NULL)
            var macAddress: CFData? = nil
            guard IOMasterPort(masterPort, &masterPort) == KERN_SUCCESS,
                let matchingDict = IOBSDNameMatching(masterPort, 0, "en0"),
                IOServiceGetMatchingServices(masterPort, matchingDict, &iterator) == KERN_SUCCESS
            else {
                return nil
            }
            var service: io_object_t = UInt32(MACH_PORT_NULL)
            func nextService() -> Bool {
                service = IOIteratorNext(iterator)
                return service != 0
            }
            while nextService() {
                var parentService: io_object_t = UInt32(MACH_PORT_NULL)
                if IORegistryEntryGetParentEntry(service, kIOServicePlane, &parentService) == KERN_SUCCESS {
                    macAddress = (IORegistryEntryCreateCFProperty(parentService, "IOMACAddress" as CFString, kCFAllocatorDefault, 0) as! CFData)
                    IOObjectRelease(parentService)
                }
                IOObjectRelease(service)
            }
            IOObjectRelease(iterator)
            return macAddress == nil ? nil : Data(referencing: macAddress!)
            
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
            return Data(bytes: addr, count: 16)

            #endif
        }()

    }
}
