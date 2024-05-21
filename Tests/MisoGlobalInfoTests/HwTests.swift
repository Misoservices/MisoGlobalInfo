//
//  HwTests.swift
//  
//
//  Created by Misoservices on 2024-05-21.
//

import XCTest
@testable import MisoGlobalInfo

final class HwTests: XCTestCase {
    func testSimulator() throws {
        if GlobalInfo.HW.isSimulator {
            XCTAssertNotNil(GlobalInfo.HW.simulatorModelIdentifier)
            XCTAssertNotNil(GlobalInfo.HW.simulatorFamily)
        } else {
            XCTAssertNil(GlobalInfo.HW.simulatorModelIdentifier)
            XCTAssertNil(GlobalInfo.HW.simulatorFamily)
        }
    }

    func testSystem() throws {
        XCTAssertNotNil(GlobalInfo.HW.modelIdentifier)
        XCTAssertNotNil(GlobalInfo.HW.systemFamily)
    }

    func testFamily() throws {
        XCTAssertNotEqual(GlobalInfo.HW.family, .unknown)
    }
}
