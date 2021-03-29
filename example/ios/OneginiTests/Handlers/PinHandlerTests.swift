//
//  PinHandlerTests.swift
//  OneginiTests
//
//  Created by Patryk Gałach on 29/03/2021.
//

import XCTest
@testable import onegini

class PinHandlerTests: XCTestCase, PinHandlerToReceiverProtocol {
    var handler: PinHandler?
    var pinHanlderCallback: (_ pin: String?) -> () = { _ in }
    
    override func setUpWithError() throws {
        print("[TESTS] set up with error")
        try super.setUpWithError()
        handler = PinHandler()
    }

    override func tearDownWithError() throws {
        print("[TESTS] tear down with error")
        handler = nil
        pinHanlderCallback = { _ in }
        try super.tearDownWithError()
    }

    func testProcessPinLoginMode() throws {
        let expectation = self.expectation(description: "testProcessPinLoginMode")
        handler!.pinReceiver = self
        handler!.mode = PINEntryMode.login
        
        let testPin = "12312"
        pinHanlderCallback =  {
            pin in
            XCTAssert(testPin == pin)
            expectation.fulfill()
        }
        
        handler!.processPin(pinEntry: [testPin])
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testProcessPinRegisterMode() throws {
        let expectation = self.expectation(description: "testProcessPinRegisterMode")
        handler!.pinReceiver = self
        handler!.mode = PINEntryMode.registration
        
        let testPin = "12312"
        pinHanlderCallback =  {
            pin in
            XCTAssert(testPin == pin)
            expectation.fulfill()
        }
        
        handler!.processPin(pinEntry: [testPin])
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testProcessPinNoneMode() throws {
        let expectation = self.expectation(description: "testProcessPinNoneMode")
        handler!.pinReceiver = self
        handler!.mode = nil
        
        let testPin = "12312"
        pinHanlderCallback =  {
            pin in
            XCTAssert(testPin == pin)
            expectation.fulfill()
        }
        
        handler!.processPin(pinEntry: [testPin])
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testProcessPinNoPin() throws {
        let expectation = self.expectation(description: "testProcessPinNoPin")
        handler!.pinReceiver = self
        
        pinHanlderCallback =  {
            pin in
            XCTAssert(pin == "")
            expectation.fulfill()
        }
        
        handler!.processPin(pinEntry: [])
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func handlePin(pin: String?) {
        pinHanlderCallback(pin)
    }
}
