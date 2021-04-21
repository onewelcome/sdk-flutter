//
//  AuthenticatorConnector.swift
//  onegini
//
//  Created by Patryk Gałach on 21/04/2021.
//

import Foundation

import OneginiSDKiOS

protocol AuthenticatorConnectorProtocol: FlutterNotificationReceiverProtocol {
    func getIdentityProviders(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func setPreferredAuthenticator(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func getRegisteredAuthenticators(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func getAllNotRegisteredAuthenticators(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func registerAuthenticator(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func deregisterAuthenticator(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
}

class AuthenticatorConnector: NSObject, AuthenticatorConnectorProtocol {
    
    var flutterConnector: FlutterConnectorProtocol?
    
    func getIdentityProviders(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        
        // TODO: implement wrapper
        OneginiModuleSwift.sharedInstance.identityProviders(callback: result)
    }
    
    func setPreferredAuthenticator(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        
        // TODO: implement wrapper
    }
    
    func getRegisteredAuthenticators(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        
        // TODO: implement wrapper
        OneginiModuleSwift.sharedInstance.fetchRegisteredAuthenticators(callback: result)
    }
    
    func getAllNotRegisteredAuthenticators(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        
        // TODO: implement wrapper
        OneginiModuleSwift.sharedInstance.fetchNotRegisteredAuthenticator(callback: result)
    }
    
    func registerAuthenticator(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        
        // TODO: implement wrapper
    }
    
    func deregisterAuthenticator(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        
        // TODO: implement wrapper
    }
    
}
