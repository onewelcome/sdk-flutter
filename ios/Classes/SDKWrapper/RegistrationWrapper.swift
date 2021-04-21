//
//  RegistrationWrapper.swift
//  onegini
//
//  Created by Patryk Gałach on 17/04/2021.
//

import OneginiSDKiOS

// MARK: Wrapper Protocol
protocol RegistrationWrapperProtocol {
    func register(identityProvider: ONGIdentityProvider?, scopes: Array<String>?)
    
    var createPin: ((CreatePinChallengeProtocol) -> Void)? { get set }
    var browserRegistration: ((BrowserRegistrationChallengeProtocol) -> Void)? { get set }
    var registrationSuccess: ((ONGUserProfile, ONGCustomInfo?) -> Void)? { get set }
    var registrationFailed: ((Error) -> Void)? { get set }
}

// MARK: Wrapper
class RegistrationWrapper: NSObject, RegistrationWrapperProtocol {
    
    // callbacks
    var createPin: ((CreatePinChallengeProtocol) -> Void)?
    var browserRegistration: ((BrowserRegistrationChallengeProtocol) -> Void)?
    var registrationSuccess: ((ONGUserProfile, ONGCustomInfo?) -> Void)?
    var registrationFailed: ((Error) -> Void)?
    
    // methods
    func register(identityProvider: ONGIdentityProvider?, scopes: Array<String>?) {
        ONGUserClient.sharedInstance().registerUser(with: identityProvider, scopes: scopes, delegate: self)
    }
}

extension RegistrationWrapper: ONGRegistrationDelegate {
    func userClient(_ userClient: ONGUserClient, didReceivePinRegistrationChallenge challenge: ONGCreatePinChallenge) {
        
        // make a factory for challenges?
        createPin?(CreatePinChallenge.init(challenge: challenge))
    }
    
    func userClient(_ userClient: ONGUserClient, didReceive challenge: ONGBrowserRegistrationChallenge) {
        
        // make a factory for challenges?
        browserRegistration?(BrowserRegistrationChallenge.init(challenge: challenge))
    }
    
    func userClient(_ userClient: ONGUserClient, didRegisterUser userProfile: ONGUserProfile, info : ONGCustomInfo?) {
        registrationSuccess?(userProfile, info)
    }
    
    func userClient(_ userClient: ONGUserClient, didFailToRegisterWithError error: Error) {
        registrationFailed?(error)
    }
}
