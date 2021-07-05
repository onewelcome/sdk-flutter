//
//  RegisterUserWrapper.swift
//  onegini
//
//  Created by Dream Store on 05.05.2021.
//

import Foundation
import OneginiSDKiOS

//MARK:- RegistrationWrapper
protocol RegisterUserWrapperProtocol {
    func register(identityProvider: ONGIdentityProvider?, scopes: Array<String>?)
    
    var createPinCallback: ((CreatePinChallengeProtocol) -> Void)? { get set }
    var browserRegistrationCallback: ((BrowserRegistrationChallengeProtocol) -> Void)? { get set }
    var registrationSuccessCallback: ((ONGUserProfile, ONGCustomInfo?) -> Void)? { get set }
    var registrationFailedCallback: ((Error) -> Void)? { get set }
}

// MARK: Wrapper
class RegisterUserWrapper: NSObject, RegisterUserWrapperProtocol {
    
    // callbacks
    var createPinCallback: ((CreatePinChallengeProtocol) -> Void)?
    var browserRegistrationCallback: ((BrowserRegistrationChallengeProtocol) -> Void)?
    var registrationSuccessCallback: ((ONGUserProfile, ONGCustomInfo?) -> Void)?
    var registrationFailedCallback: ((Error) -> Void)?
    
    // methods
    func register(identityProvider: ONGIdentityProvider?, scopes: Array<String>?) {
        ONGUserClient.sharedInstance().registerUser(with: identityProvider, scopes: scopes, delegate: self)
    }
}

extension RegisterUserWrapper: ONGRegistrationDelegate {
    func userClient(_ userClient: ONGUserClient, didReceivePinRegistrationChallenge challenge: ONGCreatePinChallenge) {
        
        createPinCallback?(CreatePinChallenge.init(challenge: challenge))
    }
    
    func userClient(_ userClient: ONGUserClient, didReceive challenge: ONGBrowserRegistrationChallenge) {
        
        browserRegistrationCallback?(BrowserRegistrationChallenge.init(challenge: challenge))
    }
    
    func userClient(_ userClient: ONGUserClient, didRegisterUser userProfile: ONGUserProfile, info : ONGCustomInfo?) {
        registrationSuccessCallback?(userProfile, info)
    }
    
    func userClient(_ userClient: ONGUserClient, didFailToRegisterWithError error: Error) {
        registrationFailedCallback?(error)
    }
}
