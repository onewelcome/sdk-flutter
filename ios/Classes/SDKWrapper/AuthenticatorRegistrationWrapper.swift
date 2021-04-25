//
//  AuthenticatorRegistrationWrapper.swift
//  onegini
//
//  Created by Patryk Gałach on 25/04/2021.
//

import OneginiSDKiOS

// MARK: Wrapper Protocol
protocol AuthenticatorRegistrationWrapperProtocol {
    func registerAuthenticator(authenticator: ONGAuthenticator)
}

// MARK: Wrapper
class AuthenticatorRegistrationWrapper: NSObject, AuthenticatorRegistrationWrapperProtocol {
    func registerAuthenticator(authenticator: ONGAuthenticator) {
        ONGUserClient.sharedInstance().register(authenticator, delegate: self)
    }
}

extension AuthenticatorRegistrationWrapper: ONGAuthenticatorRegistrationDelegate {
    // TODO: implement callbacks
}
