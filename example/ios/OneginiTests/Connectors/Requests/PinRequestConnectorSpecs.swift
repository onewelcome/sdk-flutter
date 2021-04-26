//
//  PinRequestConnectorSpecs.swift
//  OneginiTests
//
//  Created by Patryk Gałach on 26/04/2021.
//

import Quick
import Nimble
import OneginiSDKiOS
@testable import onegini

class PinRequestConnectorSpecs: QuickSpec {
    
    var acceptPinCallback: ((_ pin: String) -> Void)?
    var denyPinCallback: (() -> Void)?
    
    override func spec() {
        
        var connector: PinRequestConnector?
        
        describe("pin request connector") {
            
            afterEach {
                connector = nil
                self.acceptPinCallback = nil
                self.denyPinCallback = nil
            }
            
            beforeEach {
                connector = PinRequestConnector()
            }
            
            describe("assign listener") {
                
                it("expect accept callback") {
                    
                    waitUntil { done in
                        
                        connector?.addListener(listener: self)
                        
                        self.acceptPinCallback = {
                            pin in
                            
                            expect(pin.count).to(beGreaterThan(0))
                            done()
                        }
                        
                        let method = FlutterMethodCall(
                            methodName: Constants.Routes.acceptPinRegistrationRequest,
                            arguments: [Constants.Parameters.pin: "12345"])
                        let result: FlutterResult = { val in /* don't need result in this case */}
                        
                        connector?.acceptPin(method, result)
                    }
                }
                
                it("expect deny callback") {
                    
                    waitUntil { done in
                        
                        connector?.addListener(listener: self)
                        
                        self.denyPinCallback = {
                            done()
                        }
                        
                        let method = FlutterMethodCall(
                            methodName: Constants.Routes.denyPinRegistrationRequest,
                            arguments: [])
                        let result: FlutterResult = { val in /* don't need result in this case */}
                        
                        connector?.denyPin(method, result)
                    }
                }
            }
            
        }
    }
}

extension PinRequestConnectorSpecs: PinListener {
    func acceptPin(pin: String) {
        acceptPinCallback?(pin)
    }
    
    func denyPin() {
        denyPinCallback?()
    }
}
