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
    var plugin: SwiftOneginiPlugin? = SwiftOneginiPlugin()
    var module: OneginiModuleSwift?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
//        plugin = SwiftOneginiPlugin()
        module = OneginiModuleSwift.sharedInstance
    }

    override func tearDownWithError() throws {
//        plugin = nil
        module = nil
        try super.tearDownWithError()
    }

    func testaaaStartApp() throws {
        let call = FlutterMethodCall(methodName: "startApp",
                                     arguments: ["readTimeout": 25,
                                                 "twoStepCustomIdentityProviderIds": "2-way-otp-api",
                                                 "connectionTimeout": 5] )
        let expectation = self.expectation(description: "startApp")
        
        plugin!.handle( call, result: { (result) -> Void in
            print ("[\(type(of: self))](testaaaStartApp) result type: \(type(of: result!))\n result description " + result.debugDescription)
            
            XCTAssert(result is String)
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testGetIdentityProviders() throws {
        let call = FlutterMethodCall( methodName: "getIdentityProviders", arguments: nil )
        let expectation = self.expectation(description: "getIdentityProviders")
        
        plugin!.handle( call, result: {(result)->Void in
            print ("[\(type(of: self))](testGetIdentityProviders) result type: \(type(of: result!))\n result description " + result.debugDescription)
            
            XCTAssert(result is String)
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetRegisteredAuthenticators() throws {
        let call = FlutterMethodCall( methodName: "getRegisteredAuthenticators", arguments: nil )
        let expectation = self.expectation(description: "getRegisteredAuthenticators")
        
        plugin!.handle( call, result: {(result)->Void in
            print ("[\(type(of: self))](testGetRegisteredAuthenticators) result type: \(type(of: result!))\n result description " + result.debugDescription)
            
            XCTAssert(!(result is FlutterError))
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetAllNotRegisteredAuthenticators() throws {
        let call = FlutterMethodCall( methodName: "getAllNotRegisteredAuthenticators", arguments: nil )
        let expectation = self.expectation(description: "getAllNotRegisteredAuthenticators")
        
        plugin!.handle( call, result: {(result)->Void in
            print ("[\(type(of: self))](testGetAllNotRegisteredAuthenticators) result type: \(type(of: result!))\n result description " + result.debugDescription)
            
            XCTAssert(!(result is FlutterError))
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testaAuthenticateUserWithPinSuccessful() throws {
        
        let call = FlutterMethodCall( methodName: "authenticateUser",
                                      arguments: ["registeredAuthenticatorId": nil] )
        let expectation = self.expectation(description: "testAuthenticateUserWithPin")
        
        plugin!.handle( call, result: {(result)->Void in
            print ("[\(type(of: self))](testaAuthenticateUserWithPin) result type: \(type(of: result!))\n result description: \(result.debugDescription) ")
            
            if let error = result as? FlutterError {
                print("[\(type(of: self))] error: \(error)")
            }
            
            XCTAssert(!(result is FlutterError))
            expectation.fulfill()
        })
        
        try acceptPinAuthenticationRequest()
        
        waitForExpectations(timeout: 15, handler: nil)
    }
    
    func testaAuthenticateUserWithPinDenied() throws {
        
        let call = FlutterMethodCall( methodName: "authenticateUser",
                                      arguments: ["registeredAuthenticatorId": nil] )
        let expectation = self.expectation(description: "testAuthenticateUserWithPin")
        
        plugin!.handle( call, result: {(result)->Void in
            print ("[\(type(of: self))](testaAuthenticateUserWithPin) result type: \(type(of: result!))\n result description: \(result.debugDescription) ")
            
            if let error = result as? FlutterError {
                print("[\(type(of: self))] error: \(error)")
            }
            
            XCTAssert(result is FlutterError)
            expectation.fulfill()
        })
        
        try denyPinAuthenticationRequest()
        
        waitForExpectations(timeout: 15, handler: nil)
    }
    
    func acceptPinAuthenticationRequest() throws {
        let call = FlutterMethodCall( methodName: "acceptPinAuthenticationRequest",
                                      arguments: ["pin": "55663"] )
        
        plugin!.handle( call, result: {(result)->Void in })
    }
    
    func denyPinAuthenticationRequest() throws {
        let call = FlutterMethodCall( methodName: "denyPinAuthenticationRequest",
                                      arguments: nil )
        plugin!.handle( call, result: {(result)->Void in })
    }
    
    func testzDeregisterUser() throws {
        let call = FlutterMethodCall( methodName: "deregisterUser", arguments: nil )
        let expectation = self.expectation(description: "deregisterUser")
        
        plugin!.handle( call, result: {(result)->Void in
            print ("[\(type(of: self))](testDeregisterUser) result type: \(type(of: result!))\n result description " + result.debugDescription)
            
            XCTAssert(!(result is FlutterError))
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testzLogout() throws {
        let call = FlutterMethodCall( methodName: "logout", arguments: nil )
        let expectation = self.expectation(description: "logout")
        
        plugin!.handle( call, result: {(result)->Void in
            print ("[\(type(of: self))](testLogout) result type: \(type(of: result!))\n result description " + result.debugDescription)
            
            XCTAssert(!(result is FlutterError))
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testNotImplementedMethod() throws {
        let call = FlutterMethodCall( methodName: "notImplementedMethodName", arguments: nil )
        let expectation = self.expectation(description: "notImplementedMethodName")
        
        plugin!.handle( call, result: {(result)->Void in
            print ("[\(type(of: self))](testNotImplementedMethod) result type: \(type(of: result!))\n result description " + result.debugDescription)
            
            XCTAssert(!(result is String))
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 1, handler: nil)
    }
}
