//
//  AuthenticatorsHandler_SetPrefferedAuthenticatorTests.swift
//  OneginiTests
//
//  Created by Mateusz Mirkowski on 07/04/2021.
//

import XCTest
import XCTest
@testable import onegini
import OneginiSDKiOS

class AuthenticatorsHandler_SetPrefferedAuthenticatorTests: XCTestCase, AuthenticatorsNotificationReceiverProtocol {
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


    func testPreferredAuthenticatorWithPin() throws {
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

        expectation = self.expectation(description: "setPreferredAuthenticator")

        handler!.setPreferredAuthenticator(profile, "0") { (success, error) in
            XCTAssertTrue(success)
            XCTAssertNil(error)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func testPreferredAuthenticatorWithBiometric() throws {
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

        expectation = self.expectation(description: "setPreferredAuthenticator")

        handler!.setPreferredAuthenticator(profile, "1") { (success, error) in
            XCTAssertTrue(success)
            XCTAssertNil(error)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func testPreferredAuthenticatorWithCustom() throws {
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

        expectation = self.expectation(description: "setPreferredAuthenticator")

        handler!.setPreferredAuthenticator(profile, "3") { (success, error) in
            XCTAssertTrue(success)
            XCTAssertNil(error)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }
}
