//
//  AppTests.swift
//
//
//  Created by Misoservices on 2024-05-21.
//

import XCTest
@testable import MisoGlobalInfo

final class AppTests: XCTestCase {
    func testAppStoreReceipt() throws {
        XCTAssertNil(GlobalInfo.App.appStoreReceipt)
        XCTAssertNil(GlobalInfo.App.appStoreReceiptURL)
    }
    func testBuild() throws {
        XCTAssertNotNil(GlobalInfo.App.buildArchitecture)
    }
    func testBundle() throws {
        XCTAssertNotNil(GlobalInfo.App.bundleVersion)
        XCTAssertNotNil(GlobalInfo.App.bundleIdentifier)
        XCTAssertNotNil(GlobalInfo.App.bundleShortVersion)
        XCTAssertNotEqual(GlobalInfo.App.bundleVersionAsInt, 0)
    }
    func testCopyright() throws {
        XCTAssertNotNil(GlobalInfo.App.copyright)
    }
    func testDisplay() throws {
        XCTAssertNotNil(GlobalInfo.App.displayName)
    }
    func testBools() throws {
        XCTAssertFalse(GlobalInfo.App.isPreview)
        let _ = GlobalInfo.App.isMacCatalyst
        XCTAssertTrue(GlobalInfo.App.isRunningTests)
        let _ = GlobalInfo.App.isiOSOnMac
        let _ = GlobalInfo.App.isMacAppleSiliconNativeCode
        XCTAssertNotNil(GlobalInfo.App.isRosetta)
    }
    func testProcess() throws {
        XCTAssertNotNil(GlobalInfo.App.processPathName)
    }
}
