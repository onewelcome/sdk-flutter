//
//  AuthenticatorRegistrationConnector.swift
//  onegini
//
//  Created by Patryk Gałach on 25/04/2021.
//

import Foundation

import OneginiSDKiOS

protocol AuthenticatorRegistrationConnectorProtocol: FlutterNotificationReceiverProtocol {
    func registerAuthenticator(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func deregisterAuthenticator(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
}

class AuthenticatorRegistrationConnector: NSObject, AuthenticatorRegistrationConnectorProtocol {
    
    var registrationWrapper: AuthenticatorRegistrationWrapperProtocol
    var deregistrationWrapper: AuthenticatorDeregistrationWrapperProtocol
    
    var userProfileConnector: UserProfileConnectorProtocol
    var authenticatorsConnector: AuthenticatorsConnectorProtocol
    
    unowned var flutterConnector: FlutterConnectorProtocol?
    
    init(registrationWrapper: AuthenticatorRegistrationWrapperProtocol, deregistrationWrapper: AuthenticatorDeregistrationWrapperProtocol, userProfileConnector: UserProfileConnectorProtocol, authenticatorsConnector: AuthenticatorsConnectorProtocol) {
        self.registrationWrapper = registrationWrapper
        self.deregistrationWrapper = deregistrationWrapper
        self.userProfileConnector = userProfileConnector
        self.authenticatorsConnector = authenticatorsConnector
        
        super.init()
    }
    
    func registerAuthenticator(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        var authenticatorId: String?
        
        if let arg = call.arguments as! [String: Any]? {
            authenticatorId = arg[Constants.Parameters.authenticatorId] as? String
        }
        
        guard let user = userProfileConnector.getAuthenticatedUser() else {
            result(SdkError(customType: .noUserAuthenticated))
            return
        }
        
        guard let authenticator = authenticatorsConnector.getAuthenticator(user: user, authenticatorId: authenticatorId) else {
            result(SdkError(customType: .noSuchAuthenticator))
            return
        }
        
        registrationWrapper.registerAuthenticator(authenticator: authenticator)
    }
    
    func deregisterAuthenticator(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        var authenticatorId: String?
        
        if let arg = call.arguments as! [String: Any]? {
            authenticatorId = arg[Constants.Parameters.authenticatorId] as? String
        }
        
        guard let user = userProfileConnector.getAuthenticatedUser() else {
            result(SdkError(customType: .noUserAuthenticated))
            return
        }
        
        guard let authenticator = authenticatorsConnector.getAuthenticator(user: user, authenticatorId: authenticatorId) else {
            result(SdkError(customType: .noSuchAuthenticator))
            return
        }
        
        deregistrationWrapper.deregisterAuthenticator(authenticator: authenticator)
    }
}
