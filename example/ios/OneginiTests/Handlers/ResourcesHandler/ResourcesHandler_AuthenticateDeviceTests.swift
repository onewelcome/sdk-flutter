//
//  ResourcesHandler_authenticateDevice.swift
//  OneginiTests
//
//  Created by Mateusz Mirkowski on 30/03/2021.
//

import XCTest
@testable import onegini

class ResourcesHandler_AuthenticateDeviceTests: XCTestCase {
    var handler: ResourcesHandler?

    override func setUpWithError() throws {
        try super.setUpWithError()
        handler = ResourcesHandler()
    }

    override func tearDownWithError() throws {
        handler = nil
        try super.tearDownWithError()
    }

    func testAuthenticateDeviceWithApplicationDetails() throws {
        var expectation = self.expectation(description: "startOneginiModule")

        OneginiModuleSwift.sharedInstance.startOneginiModule { (callback) in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)

        let path = "application-details"
        expectation = self.expectation(description: path)

        handler?.authenticateDevice(path, completion: { (success, error) in
            XCTAssertTrue(success)
            XCTAssertNil(error)

            expectation.fulfill()
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
}
