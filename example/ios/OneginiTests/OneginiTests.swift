//
//  OneginiTests.swift
//  OneginiTests
//
//  Created by Patryk Gałach on 26/03/2021.
//

import XCTest
@testable import Flutter
@testable import onegini

class OneginiTests: XCTestCase {
    var plugin: SwiftOneginiPlugin?
    var module: OneginiModuleSwift?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        print("[TESTS] set up with error")
        try super.setUpWithError()
        plugin = SwiftOneginiPlugin()
        module = OneginiModuleSwift.sharedInstance
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        print("[TESTS] tear down")
        plugin = nil
        module = nil
        try super.tearDownWithError()
    }

    func testaStartApp() throws {
        let call = FlutterMethodCall(methodName: "startApp",
                                     arguments: ["readTimeout": 25,
                                                 "twoStepCustomIdentityProviderIds": "2-way-otp-api",
                                                 "connectionTimeout": 5] )
        let expectation = self.expectation(description: "startApp")
        
        plugin!.handle( call, result: { (result) -> Void in
            print ("[TEST - startApp] result type: \(type(of: result!))\n result description " + result.debugDescription)
            
            XCTAssert(result is String)
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetIdentityProviders() throws {
        let call = FlutterMethodCall( methodName: "getIdentityProviders", arguments: nil )
        let expectation = self.expectation(description: "getIdentityProviders")
        
        plugin!.handle( call, result: {(result)->Void in
            print ("[TEST - getIdentityProviders] result type: \(type(of: result!))\n result description " + result.debugDescription)
            
            XCTAssert(result is String)
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetRegisteredAuthenticators() throws {
        let call = FlutterMethodCall( methodName: "getRegisteredAuthenticators", arguments: nil )
        let expectation = self.expectation(description: "getRegisteredAuthenticators")
        
        plugin!.handle( call, result: {(result)->Void in
            print ("[TEST - getRegisteredAuthenticators] result type: \(type(of: result!))\n result description " + result.debugDescription)
            
            XCTAssert(!(result is FlutterError))
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetAllNotRegisteredAuthenticators() throws {
        let call = FlutterMethodCall( methodName: "getAllNotRegisteredAuthenticators", arguments: nil )
        let expectation = self.expectation(description: "getAllNotRegisteredAuthenticators")
        
        plugin!.handle( call, result: {(result)->Void in
            print ("[TEST - getAllNotRegisteredAuthenticators] result type: \(type(of: result!))\n result description " + result.debugDescription)
            
            XCTAssert(!(result is FlutterError))
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testDeregisterUser() throws {
        let call = FlutterMethodCall( methodName: "deregisterUser", arguments: nil )
        let expectation = self.expectation(description: "deregisterUser")
        
        plugin!.handle( call, result: {(result)->Void in
            print ("[TEST - deregisterUser] result type: \(type(of: result!))\n result description " + result.debugDescription)
            
            XCTAssert(!(result is FlutterError))
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testLogout() throws {
        let call = FlutterMethodCall( methodName: "logout", arguments: nil )
        let expectation = self.expectation(description: "logout")
        
        plugin!.handle( call, result: {(result)->Void in
            print ("[TEST - logout] result type: \(type(of: result!))\n result description " + result.debugDescription)
            
            XCTAssert(!(result is FlutterError))
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testNotImplementedMethod() throws {
        let call = FlutterMethodCall( methodName: "notImplementedMethodName", arguments: nil )
        let expectation = self.expectation(description: "notImplementedMethodName")
        
        plugin!.handle( call, result: {(result)->Void in
            print ("[TEST - notImplementedMethodName] result type: \(type(of: result!))\n result description " + result.debugDescription)
            
            XCTAssert(!(result is String))
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
