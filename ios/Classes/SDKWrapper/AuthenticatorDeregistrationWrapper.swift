//
//  AuthenticatorDeregistrationWrapper.swift
//  onegini
//
//  Created by Patryk Gałach on 25/04/2021.
//

import OneginiSDKiOS

// MARK: Wrapper Protocol
protocol AuthenticatorDeregistrationWrapperProtocol {
    func deregisterAuthenticator(authenticator: ONGAuthenticator)
}

// MARK: Wrapper
class AuthenticatorDeregistrationWrapper: NSObject, AuthenticatorDeregistrationWrapperProtocol {
    func deregisterAuthenticator(authenticator: ONGAuthenticator) {
        ONGUserClient.sharedInstance().deregister(authenticator, delegate: self)
    }
}

extension AuthenticatorDeregistrationWrapper: ONGAuthenticatorDeregistrationDelegate {
    // TODO: implement callbacks
}
