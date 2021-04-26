//
//  BiometricRequestConnectorSpecs.swift
//  OneginiTests
//
//  Created by Patryk Gałach on 26/04/2021.
//

import Quick
import Nimble
import OneginiSDKiOS
@testable import onegini

class BiometricRequestConnectorSpecs: QuickSpec {
    
    var acceptBiometricCallback: ((_ prompt: String) -> Void)?
    var fallbackToPinCallback: (() -> Void)?
    var denyBiometricCallback: (() -> Void)?
    
    override func spec() {
        
        var connector: BiometricRequestConnector?
        
        describe("biometric request connector") {
            
            afterEach {
                connector = nil
                self.acceptBiometricCallback = nil
                self.fallbackToPinCallback = nil
                self.denyBiometricCallback = nil
            }
            
            beforeEach {
                connector = BiometricRequestConnector()
            }
            
            describe("assign listener") {
                
                it("expect accept callback") {
                    
                    waitUntil { done in
                        
                        connector?.addListener(listener: self)
                        
                        self.acceptBiometricCallback = {
                            prompt in
                            
                            expect(prompt.count).to(beGreaterThan(0))
                            done()
                        }
                        
                        let method = FlutterMethodCall(
                            methodName: Constants.Routes.acceptFingerprintAuthenticationRequest,
                            arguments: [Constants.Parameters.prompt: "some data"])
                        let result: FlutterResult = { val in /* don't need result in this case */}
                        
                        connector?.acceptBiometric(method, result)
                    }
                }
                
                it("expect fallback callback") {
                    
                    waitUntil { done in
                        
                        connector?.addListener(listener: self)
                        
                        self.fallbackToPinCallback = {
                            
                            done()
                        }
                        
                        let method = FlutterMethodCall(
                            methodName: Constants.Routes.fingerprintFallbackToPin,
                            arguments: [])
                        let result: FlutterResult = { val in /* don't need result in this case */}
                        
                        connector?.fallbackToPin(method, result)
                    }
                }
                
                it("expect deny callback") {
                    
                    waitUntil { done in
                        
                        connector?.addListener(listener: self)
                        
                        self.denyBiometricCallback = {
                            done()
                        }
                        
                        let method = FlutterMethodCall(
                            methodName: Constants.Routes.denyFingerprintAuthenticationRequest,
                            arguments: [])
                        let result: FlutterResult = { val in /* don't need result in this case */}
                        
                        connector?.denyBiometric(method, result)
                    }
                }
            }
            
        }
    }
}

extension BiometricRequestConnectorSpecs: BiometricListener {
    func acceptBiometric(prompt: String) {
        acceptBiometricCallback?(prompt)
    }
    
    func fallbackToPin() {
        fallbackToPinCallback?()
    }
    
    func denyBiometric() {
        denyBiometricCallback?()
    }
}
