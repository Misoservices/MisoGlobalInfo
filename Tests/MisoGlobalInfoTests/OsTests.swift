//
//  OsTests.swift
//  
//
//  Created by Misoservices on 2024-05-21.
//

import XCTest
@testable import MisoGlobalInfo

final class OsTests: XCTestCase {
    func testVersion() throws {
        XCTAssertFalse(GlobalInfo.OS.localizedVersion.isEmpty)
        XCTAssertNotEqual(GlobalInfo.OS.majorVersion, 0)
        let _ = GlobalInfo.OS.minorVersion
        let _ = GlobalInfo.OS.patchVersion
    }

    func testUuid() throws {
        XCTAssertNotNil(GlobalInfo.OS.uuid)
    }
}
