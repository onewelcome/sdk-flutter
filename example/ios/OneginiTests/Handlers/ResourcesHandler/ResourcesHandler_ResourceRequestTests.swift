//
//  ResourcesHandler_resourceTests.swift
//  OneginiTests
//
//  Created by Mateusz Mirkowski on 30/03/2021.
//

import XCTest
import XCTest
@testable import onegini
import OneginiSDKiOS

class ResourcesHandler_ResourceRequestTests: XCTestCase {
    var handler: ResourcesHandler?

    override func setUpWithError() throws {
        try super.setUpWithError()
        handler = ResourcesHandler()
    }

    override func tearDownWithError() throws {
        handler = nil
        try super.tearDownWithError()
    }

    func testResourceRequestWithImplicitlyError() throws {
        var expectation = self.expectation(description: "startOneginiModule")

        OneginiModuleSwift.sharedInstance.startOneginiModule { (callback) in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)

        expectation = self.expectation(description: "authenticateImplicitly")

        var parameters = [String: Any]()
        parameters["path"] = "devices"
        parameters["encoding"] = "application/x-www-form-urlencoded";
        parameters["method"] = "GET"

        handler?.resourceRequest(isImplicit: true, parameters: parameters, completion: { (success, error) in
            XCTAssertNil(success)
            XCTAssertNotNil(error)
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testResourceRequestWithNoImplicitlyError() throws {
        var expectation = self.expectation(description: "startOneginiModule")

        OneginiModuleSwift.sharedInstance.startOneginiModule { (callback) in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)

        expectation = self.expectation(description: "authenticateImplicitly")

        var parameters = [String: Any]()
        parameters["path"] = "application-details"
        parameters["encoding"] = "application/x-www-form-urlencoded";
        parameters["method"] = "GET"

        handler?.resourceRequest(isImplicit: false, parameters: parameters, completion: { (success, error) in
            XCTAssertNil(success)
            XCTAssertNotNil(error)
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)
    }
}
