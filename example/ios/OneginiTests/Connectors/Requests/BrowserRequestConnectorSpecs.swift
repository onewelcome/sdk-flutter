//
//  BrowserRequestConnectorSpecs.swift
//  OneginiTests
//
//  Created by Patryk Gałach on 26/04/2021.
//

import Quick
import Nimble
import OneginiSDKiOS
@testable import onegini

class BrowserRequestConnectorSpecs: QuickSpec {
    
    var acceptUrlCallback: ((_ url: URL) -> Void)?
    var denyUrlCallback: (() -> Void)?
    
    override func spec() {
        
        var connector: BrowserRequestConnector?
        
        describe("browser request connector") {
            
            afterEach {
                connector = nil
                self.acceptUrlCallback = nil
                self.denyUrlCallback = nil
            }
            
            beforeEach {
                connector = BrowserRequestConnector()
            }
            
            describe("assign listener") {
                
                it("expect accept callback") {
                    
                    waitUntil { done in
                        
                        connector?.addListener(listener: self)
                        
                        self.acceptUrlCallback = {
                            url in
                            
                            expect(url.absoluteString.count).to(beGreaterThan(0))
                            done()
                        }
                        
                        let method = FlutterMethodCall(
                            methodName: Constants.Routes.acceptPinRegistrationRequest, // TODO: create acceptUrlRequest
                            arguments: [Constants.Parameters.url: "https://test.com"])
                        let result: FlutterResult = { val in /* don't need result in this case */}
                        
                        connector?.acceptUrl(method, result)
                    }
                }
                
                it("expect deny callback") {
                    
                    waitUntil { done in
                        
                        connector?.addListener(listener: self)
                        
                        self.denyUrlCallback = {
                            done()
                        }
                        
                        let method = FlutterMethodCall(
                            methodName: Constants.Routes.denyPinRegistrationRequest, // TODO: create denyUrlRequest
                            arguments: [])
                        let result: FlutterResult = { val in /* don't need result in this case */}
                        
                        connector?.denyUrl(method, result)
                    }
                }
            }
            
        }
    }
}

extension BrowserRequestConnectorSpecs: BrowserListener {
    func acceptUrl(url: URL) {
        acceptUrlCallback?(url)
    }
    
    func denyUrl() {
        denyUrlCallback?()
    }
}
