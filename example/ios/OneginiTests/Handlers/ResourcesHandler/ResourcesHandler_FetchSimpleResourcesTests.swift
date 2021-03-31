//
//  ResourcesHandler_FetchSimpleResourcesTests.swift
//  OneginiTests
//
//  Created by Mateusz Mirkowski on 30/03/2021.
//

import XCTest
@testable import onegini
import OneginiSDKiOS

class ResourcesHandler_FetchSimpleResourcesTests: XCTestCase {
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
    func testFetchSimpleResourceWithApplicationDetails() throws {
        var expectation = self.expectation(description: "startOneginiModule")

        OneginiModuleSwift.sharedInstance.startOneginiModule { (callback) in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)

        expectation = self.expectation(description: "testSignUpWithDummyId")

        let dummyProviderId = "Dummy-IDP"
        let registrationHandler = RegistrationHandler()
        registrationHandler.signUp(dummyProviderId, completion: { (success, userProfile, error) in
            print("[REGISTRATIONHANDLER] sign complete with dummy")
            print("[REGISTRATIONHANDLER] success: \(success) ; profile: \(userProfile.debugDescription) ; error: \(error!.errorDescription)")
            expectation.fulfill()
        })

        waitForExpectations(timeout: 5, handler: nil)


        expectation = self.expectation(description: "application-details")

        var parameters = [String: Any]()
        parameters["path"] = "devices"
        parameters["encoding"] = "application/x-www-form-urlencoded";
        parameters["method"] = "application-details"

        handler?.fetchSimpleResources("application-details", parameters: parameters, completion: { (result) in
            print("resullll")
            print((result as! FlutterError).details)
            expectation.fulfill()
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
}
