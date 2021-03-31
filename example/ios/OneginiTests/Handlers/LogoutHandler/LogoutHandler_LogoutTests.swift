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
        var expectation = self.expectation(description: "startOneginiModule")

        OneginiModuleSwift.sharedInstance.startOneginiModule { (callback) in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)

        expectation = self.expectation(description: "logout")

        handler?.logout(completion: { (error) in
            XCTAssertNil(error)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 5, handler: nil)
    }


}
