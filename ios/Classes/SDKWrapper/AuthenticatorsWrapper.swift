//
//  AuthenticatorsWrapper.swift
//  onegini
//
//  Created by Patryk Gałach on 25/04/2021.
//

import OneginiSDKiOS

// MARK: Wrapper Protocol
protocol AuthenticatorsWrapperProtocol {
    func setPreferredAuthenticator(newPreferredAuthenticator: ONGAuthenticator)
    func getRegisteredAuthenticators(forUser user: ONGUserProfile) -> [ONGAuthenticator]
    func getAllNotRegisteredAuthenticators(forUser user: ONGUserProfile) -> [ONGAuthenticator]
    func getAllAuthenticators(forUser user: ONGUserProfile) -> [ONGAuthenticator]
}

// MARK: Wrapper
class AuthenticatorsWrapper: NSObject, AuthenticatorsWrapperProtocol {
    func setPreferredAuthenticator(newPreferredAuthenticator: ONGAuthenticator) {
        ONGUserClient.sharedInstance().preferredAuthenticator = newPreferredAuthenticator
    }
    
    func getRegisteredAuthenticators(forUser user: ONGUserProfile) -> [ONGAuthenticator] {
        let registered = Array(ONGUserClient.sharedInstance().registeredAuthenticators(forUser: user))
        return registered
    }
    
    func getAllNotRegisteredAuthenticators(forUser user: ONGUserProfile) -> [ONGAuthenticator] {
        let notRegistered = Array(ONGUserClient.sharedInstance().nonRegisteredAuthenticators(forUser: user))
        return notRegistered
    }
    
    func getAllAuthenticators(forUser user: ONGUserProfile) -> [ONGAuthenticator] {
        let authenticators = Array(ONGUserClient.sharedInstance().allAuthenticators(forUser: user))
        return authenticators
    }
}
