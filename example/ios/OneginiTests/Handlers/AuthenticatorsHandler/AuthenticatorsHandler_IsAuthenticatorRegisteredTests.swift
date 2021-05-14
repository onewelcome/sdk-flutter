//
//  AuthenticatorsHandler_IsAuthenticatedTests.swift
//  OneginiTests
//
//  Created by Mateusz Mirkowski on 07/04/2021.
//

import XCTest
@testable import onegini
import OneginiSDKiOS

class AuthenticatorsHandler_IsAuthenticatorRegisteredTests: XCTestCase, AuthenticatorsNotificationReceiverProtocol {
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

    func testIsAuthenticatorRegisteredForPin() throws {
        var expectation = self.expectation(description: "startOneginiModule")
        OneginiModuleSwift.sharedInstance.startOneginiModule { (callback) in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)

        expectation = self.expectation(description: "isAuthenticatorRegistered")

        authHandlerCallback = {
            (event, requestMessage, error) in
            Logger.log("auth handler callback")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)

        let profile = ONGUserProfile(id: "121212")!

        let result = handler!.isAuthenticatorRegistered(.PIN, profile)
        XCTAssertTrue(result)
    }

    func testIsAuthenticatorRegisteredForBiometric() throws {
        var expectation = self.expectation(description: "startOneginiModule")
        OneginiModuleSwift.sharedInstance.startOneginiModule { (callback) in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)

        expectation = self.expectation(description: "isAuthenticatorRegistered")

        authHandlerCallback = {
            (event, requestMessage, error) in
            print("auth handler callback")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)

        let profile = ONGUserProfile(id: "121212")!

        let result = handler!.isAuthenticatorRegistered(.biometric, profile)
        XCTAssertTrue(result)
    }

    func testIsAuthenticatorRegisteredForTouchId() throws {
        var expectation = self.expectation(description: "startOneginiModule")
        OneginiModuleSwift.sharedInstance.startOneginiModule { (callback) in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)

        expectation = self.expectation(description: "isAuthenticatorRegistered")

        authHandlerCallback = {
            (event, requestMessage, error) in
            print("auth handler callback")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)

        let profile = ONGUserProfile(id: "121212")!

        let result = handler!.isAuthenticatorRegistered(.touchID, profile)
        XCTAssertTrue(result)
    }

    func testIsAuthenticatorRegisteredForCustom() throws {
        var expectation = self.expectation(description: "startOneginiModule")
        OneginiModuleSwift.sharedInstance.startOneginiModule { (callback) in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)

        expectation = self.expectation(description: "isAuthenticatorRegistered")

        authHandlerCallback = {
            (event, requestMessage, error) in
            print("auth handler callback")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)

        let profile = ONGUserProfile(id: "121212")!

        let result = handler!.isAuthenticatorRegistered(.custom, profile)
        XCTAssertTrue(result)
    }
}
