//
//  LogoutHandler_LogoutTests.swift
//  OneginiTests
//
//  Created by Mateusz Mirkowski on 31/03/2021.
//

import XCTest
@testable import onegini

class LogoutHandler_LogoutTests: XCTestCase {
    
    var handler: LogoutHandler?

    override func setUpWithError() throws {
        try super.setUpWithError()
        handler = LogoutHandler()
    }

    override func tearDownWithError() throws {
        handler = nil
        try super.tearDownWithError()
    }

    func testLogout() throws {
        let expectation = self.expectation(description: "testLogout")

        handler?.logout(completion: { (error) in
            expectation.fulfill()
        })

        waitForExpectations(timeout: 5, handler: nil)
    }
}
