//
//  AuthenticatorsConnector.swift
//  onegini
//
//  Created by Patryk Gałach on 21/04/2021.
//

import Foundation

import OneginiSDKiOS

protocol AuthenticatorsConnectorProtocol {
    func addCustomAuthenticators(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func setPreferredAuthenticator(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func getRegisteredAuthenticators(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func getAllNotRegisteredAuthenticators(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    
    func getAuthenticator(user: ONGUserProfile, authenticatorId: String?) -> ONGAuthenticator?
}

class AuthenticatorsConnector: NSObject, AuthenticatorsConnectorProtocol {
    
    var wrapper: AuthenticatorsWrapperProtocol
    var userProfileConnector: UserProfileConnectorProtocol
    
    init(authenticatorsWrapper: AuthenticatorsWrapperProtocol, userProfileConnector: UserProfileConnectorProtocol) {
        wrapper = authenticatorsWrapper
        self.userProfileConnector = userProfileConnector
        
        super.init()
    }
    
    func addCustomAuthenticators(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        // TODO: implement
    }
    
    func setPreferredAuthenticator(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        
        var authenticatorId: String?
        
        if let arg = call.arguments as! [String: Any]? {
            authenticatorId = arg[Constants.Parameters.authenticatorId] as? String
        }
        
        guard let profile = userProfileConnector.getAuthenticatedUser() else {
            result(SdkError.convertToFlutter(SdkError(customType: .noUserAuthenticated)))
            return
        }
        
        let registeredAuthenticators = wrapper.getRegisteredAuthenticators(forUser: profile)
        
        guard let foundAuthenticator = registeredAuthenticators.first(where: { (authenticator) -> Bool in
            return authenticator.identifier == authenticatorId
        }) else {
            result(SdkError.convertToFlutter(SdkError(customType: .noSuchAuthenticator)))
            return
        }
        
        wrapper.setPreferredAuthenticator(newPreferredAuthenticator: foundAuthenticator)
        result(nil)
    }
    
    func getRegisteredAuthenticators(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        
        guard let profile = userProfileConnector.getAuthenticatedUser() else {
            result(SdkError.convertToFlutter(SdkError(customType: .noUserAuthenticated)))
            return
        }
        
        let registeredAuthenticators = wrapper.getRegisteredAuthenticators(forUser: profile)
        let authenticators: [[String: String]] = registeredAuthenticators.compactMap({ ["id" : $0.identifier, "name": $0.name] })

        let data = String.stringify(json: authenticators)
        result(data)
    }
    
    func getAllNotRegisteredAuthenticators(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        
        guard let profile = userProfileConnector.getAuthenticatedUser() else {
            result(SdkError.convertToFlutter(SdkError(customType: .noUserAuthenticated)))
            return
        }
        
        let notRegisteredAuthenticators = wrapper.getAllNotRegisteredAuthenticators(forUser: profile)
        let authenticators: [[String: String]] = notRegisteredAuthenticators.compactMap({ ["id" : $0.identifier, "name": $0.name] })

        let data = String.stringify(json: authenticators)
        result(data)
    }
    
    func getAuthenticator(user: ONGUserProfile, authenticatorId: String?) -> ONGAuthenticator? {
        let authenticators = wrapper.getAllAuthenticators(forUser: user)
        let authenticator = authenticators.first { (auths) -> Bool in
            return auths.identifier == authenticatorId
        }
        
        return authenticator
    }
}
