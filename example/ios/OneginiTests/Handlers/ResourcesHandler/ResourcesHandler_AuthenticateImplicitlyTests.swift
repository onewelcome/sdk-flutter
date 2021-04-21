//
//  ResourcesHandler_Tests.swift
//  OneginiTests
//
//  Created by Mateusz Mirkowski on 30/03/2021.
//

import XCTest
@testable import onegini
import OneginiSDKiOS

class ResourcesHandler_AuthenticateImplicitlyTests: XCTestCase {
    var handler: ResourcesHandler?

    override func setUpWithError() throws {
        try super.setUpWithError()
        handler = ResourcesHandler()
    }

    override func tearDownWithError() throws {
        handler = nil
        try super.tearDownWithError()
    }

    // WiP
    func testAuthenticateImplicitlyWithUser() throws {
        var expectation = self.expectation(description: "startOneginiModule")

        OneginiModuleSwift.sharedInstance.startOneginiModule { (callback) in
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)

        expectation = self.expectation(description: "testAuthenticateImplicitlyWithUser")
        
        let profile = ONGUserProfile(id: "121212")
        handler?.authenticateImplicitly(profile!) { success, error in
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 15, handler: nil)
    }
}
