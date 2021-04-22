//
//  RegistrationConnectorSpecs.swift
//  OneginiTests
//
//  Created by Patryk Gałach on 22/04/2021.
//

import Quick
import Nimble
import OneginiSDKiOS
@testable import onegini

class RegistrationConnectorSpecs: QuickSpec {
    
    override func spec() {
        
        var connector: NewRegistrationConnector?
        let flutterConnector = TestFlutterListener()
        
        describe("registration connector") {
            describe("start registration") {
                
                afterEach {
                    let method = FlutterMethodCall()
                    let result: FlutterResult = { val in
                        
                    }
                    connector?.cancel(method, result)
                    connector = nil
                }
                
                beforeEach {
                    let wrapper = TestRegistrationWrapper()
                    connector = NewRegistrationConnector.init(registrationWrapper: wrapper)
                    connector?.flutterConnector = flutterConnector
                }
                
                it("expect create pin event") {
                    
                    waitUntil { done in
                        
                        flutterConnector.receiveEvent = {
                            event, data in
                            
                            let d = data as! String
                            expect(event).to(equal(.registrationNotification))
                            expect(d).to(equal(Constants.Events.eventOpenCreatePin))
                            
                            done()
                        }
                        
                        let method = FlutterMethodCall(
                            methodName: Constants.Routes.registerUser,
                            arguments: [Constants.Parameters.identityProviderId: nil,
                                        Constants.Parameters.scopes: ["read"]])
                        let result: FlutterResult = { val in /* don't need result in this case */}
                        
                        connector?.register(method, result)
                        
                    }
                    
                }
            }
        }
    }
}

class TestRegistrationWrapper: NSObject, RegistrationWrapperProtocol {
    func register(identityProvider: ONGIdentityProvider?, scopes: Array<String>?) {
        if let identityProvider = identityProvider {
            // browser / TODO: fingerprint
            browserRegistration?(TestRegistrationBrowserChallange(receiver: self))
        } else {
            // pin
            createPin?(TestRegistrationCreatePinChallange(receiver: self))
        }
    }
    
    var createPin: ((CreatePinChallengeProtocol) -> Void)?
    
    var browserRegistration: ((BrowserRegistrationChallengeProtocol) -> Void)?
    
    var registrationSuccess: ((ONGUserProfile, ONGCustomInfo?) -> Void)?
    
    var registrationFailed: ((Error) -> Void)?
}

class TestRegistrationCreatePinChallange: CreatePinChallengeProtocol {
    
    var receiver: RegistrationWrapperProtocol
    
    init(receiver: RegistrationWrapperProtocol) {
        self.receiver = receiver
    }
    
    func respond(withPin: String) {
        let userProfile = ONGUserProfile(id: "someId")!
        receiver.registrationSuccess?(userProfile, nil)
    }
    
    func cancel() {
        let error = NSError(domain: "", code: -1, userInfo: [:])
        receiver.registrationFailed?(error)
    }
}

class TestRegistrationBrowserChallange: BrowserRegistrationChallengeProtocol {
    
    var receiver: RegistrationWrapperProtocol
    
    init(receiver: RegistrationWrapperProtocol) {
        self.receiver = receiver
    }
    
    func respond(withUrl: URL) {
        let userProfile = ONGUserProfile(id: "someId")!
        receiver.registrationSuccess?(userProfile, nil)
    }
    
    func getUrl() -> URL {
        return URL.init(string: "https://test.onegini.com")!
    }
    
    func cancel() {
        let error = NSError()
        receiver.registrationFailed?(error)
    }
}
