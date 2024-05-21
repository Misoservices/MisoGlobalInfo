//
//  LoggerTests.swift
//  
//
//  Created by Misoservices on 2024-05-21.
//

import XCTest
import OSLog
@testable import MisoGlobalInfo

final class LoggerTests: XCTestCase {
    func testLoggerAppContext() throws {
        Logger.logAppContext()
    }

    func testLog() throws {
        let logger = Logger(category: "LoggerTests")
        logger.log("Test Logging")
    }
}
