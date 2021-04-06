//
//  AuthenticatorsHandlerTests.swift
//  OneginiTests
//
//  Created by Mateusz Mirkowski on 02/04/2021.
//

import XCTest
@testable import onegini
import OneginiSDKiOS

class AuthenticatorsHandler_Tests: XCTestCase, AuthenticatorsNotificationReceiverProtocol {
    var handler: AuthenticatorsHandler?
    var authHandlerCallback: ((_ event: MobileAuthNotification, _ requestMessage: String?, _ error: SdkError?) -> ())?

    override func setUpWithError() throws {
        try super.setUpWithError()
        handler = AuthenticatorsHandler()
        handler!.notificationReceiver = self
    }

    override func tearDownWithError() throws {
        handler = nil
        authHandlerCallback = nil
        try super.tearDownWithError()
    }

    func sendNotification(event: MobileAuthNotification, requestMessage: String?, error: SdkError?) {
        authHandlerCallback?(event, requestMessage, error)
    }

    func testOnCancel() throws {
        var expectation = self.expectation(description: "startOneginiModule")
        OneginiModuleSwift.sharedInstance.startOneginiModule { (callback) in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)

        expectation = self.expectation(description: "authHandlerCallback")
//        handler!.mode = PINEntryMode.login

        authHandlerCallback = {
            (event, requestMessage, error) in
            print("auth handler callback")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)

        let profile = ONGUserProfile(id: "121212")!

        expectation = self.expectation(description: "registerAuthenticator")

        handler!.registerAuthenticator(profile, ONGAuthenticator()) { (success, error) in
            XCTAssertTrue(success)
            XCTAssertNil(error)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func testGetAuthenticators() throws {
        var expectation = self.expectation(description: "startOneginiModule")
        OneginiModuleSwift.sharedInstance.startOneginiModule { (callback) in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)

        expectation = self.expectation(description: "authHandlerCallback")

        authHandlerCallback = {
            (event, requestMessage, error) in
            print("auth handler callback")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)

        let profile = ONGUserProfile(id: "121212")!

        let result = handler!.getAuthenticatorsListForUserProfile(profile)
        XCTAssertTrue(result.count > 1)
    }
}
