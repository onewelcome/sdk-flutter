//
//  TestRegistrationWrapper.swift
//  OneginiTests
//
//  Created by Patryk Gałach on 26/04/2021.
//

import OneginiSDKiOS
@testable import onegini

class TestRegistrationWrapper: NSObject, RegistrationWrapperProtocol {
    var identityProvider: ONGIdentityProvider?
    
    func register(identityProvider: ONGIdentityProvider?, scopes: Array<String>?) {
        self.identityProvider = identityProvider
        browserRegistration?(TestBrowserChallange(receiver: self))
    }
    
    var createPin: ((CreatePinChallengeProtocol) -> Void)?
    
    var browserRegistration: ((BrowserRegistrationChallengeProtocol) -> Void)?
    
    var registrationSuccess: ((ONGUserProfile, ONGCustomInfo?) -> Void)?
    
    var registrationFailed: ((Error) -> Void)?
}

extension TestRegistrationWrapper: TestBrowserListenerProtocol {
    func acceptBrowser(url: URL) {
        if let identityProvider = identityProvider {
            // TODO: fingerprint / custom
        } else {
            createPin?(TestCreatePinChallange(receiver: self))
        }
    }
    
    func denyBrowser() {
        let error = NSError(domain: "", code: -1, userInfo: [:])
        registrationFailed?(error)
    }
}

extension TestRegistrationWrapper: TestPinListenerProtocol {
    func acceptPin(pin: String) {
        let user = ONGUserProfile(id: "testId")
        registrationSuccess?(user!, nil)
    }
    
    func denyPin() {
        let error = NSError(domain: "", code: -1, userInfo: [:])
        registrationFailed?(error)
    }
}
