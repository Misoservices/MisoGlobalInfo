//
//  LoggerTests.swift
//  
//
//  Created by Misoservices on 2024-05-21.
//

import XCTest
@testable import Store

final class LoggerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLoggerAppContext() throws {
        Logger.logAppContext()
    }

    func testLog() throws {
        var logger = Logger(category: "LoggerTests")
        logger.log("Test Logging")
    }

    func testFailureLog() throws {
        var logger = Logger(category: "LoggerTests")
        XCTExpectFailureWithOptionsInBlock("Test Fault") {
            logger.fault("Test Fault")
        }
    }
}
