//
//  AuthenticationWrapper.swift
//  onegini
//
//  Created by Patryk Gałach on 25/04/2021.
//

import OneginiSDKiOS

// MARK: Wrapper Protocol
protocol AuthenticationWrapperProtocol {
    func authenticateUser(user: ONGUserProfile, authenticator: ONGAuthenticator?)
    
    var providePin: ((ProvidePinChallengeProtocol) -> Void)? { get set }
    var provideBiometric: ((BiometricChallengeProtocol) -> Void)? { get set }
    var authorizationSuccess: ((ONGUserProfile, ONGAuthenticator, ONGCustomInfo?) -> Void)? { get set }
    var authorizationFailed: ((ONGUserProfile, ONGAuthenticator, Error) -> Void)? { get set }
}

// MARK: Wrapper
class AuthenticationWrapper: NSObject, AuthenticationWrapperProtocol {
    
    // callbacks
    var providePin: ((ProvidePinChallengeProtocol) -> Void)?
    var provideBiometric: ((BiometricChallengeProtocol) -> Void)?
    var authorizationSuccess: ((ONGUserProfile, ONGAuthenticator, ONGCustomInfo?) -> Void)?
    var authorizationFailed: ((ONGUserProfile, ONGAuthenticator, Error) -> Void)?
    
    // methods
    func authenticateUser(user: ONGUserProfile, authenticator: ONGAuthenticator?) {
        ONGUserClient.sharedInstance().authenticateUser(user, authenticator: authenticator, delegate: self)
    }
}

extension AuthenticationWrapper: ONGAuthenticationDelegate {
    func userClient(_ userClient: ONGUserClient, didReceive challenge: ONGPinChallenge) {
        
        // make a factory for challenges?
        providePin?(ProvidePinChallenge.init(challenge: challenge))
    }
    
    func userClient(_ userClient: ONGUserClient, didReceive challenge: ONGBiometricChallenge) {
        
        // make a factory for challenges?
        provideBiometric?(BiometricChallenge.init(challenge: challenge))
    }
    
    func userClient(_ userClient: ONGUserClient, didReceive challenge: ONGCustomAuthFinishAuthenticationChallenge) {
        // TODO: implement in future
    }
    
    func userClient(_ userClient: ONGUserClient, didAuthenticateUser userProfile: ONGUserProfile, authenticator: ONGAuthenticator, info: ONGCustomInfo?) {
        authorizationSuccess?(userProfile, authenticator, info)
    }
    
    func userClient(_ userClient: ONGUserClient, didFailToAuthenticateUser userProfile: ONGUserProfile, authenticator: ONGAuthenticator, error: Error) {
        authorizationFailed?(userProfile, authenticator, error)
    }
}
