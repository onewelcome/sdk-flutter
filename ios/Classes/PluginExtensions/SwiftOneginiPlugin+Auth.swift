import Foundation
import OneginiSDKiOS
import OneginiCrypto
import Flutter

protocol OneginiPluginAuthProtocol {
    
    func registerAuthenticator(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    func authenticateUser(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    
    func getRegisteredAuthenticators(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    func getAllNotRegisteredAuthenticators(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    
    func acceptPinAuthenticationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    func denyPinAuthenticationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    
    func logout(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    
}

extension SwiftOneginiPlugin: OneginiPluginAuthProtocol {
    func registerAuthenticator(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard let _arg = call.arguments as! [String: Any]?, let _authenticator = _arg["authenticatorId"] as! String? else { return; }
        OneginiModuleSwift.sharedInstance.registerAuthenticator(_authenticator, callback: result)
    }
    
    func authenticateUser(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard let _arg = call.arguments as! [String: Any]? else { return; }
        let _id = _arg["registeredAuthenticatorId"] as? String
        if ((_id) != nil) {
            // auth with provider
            print("use provider for auth")
            OneginiModuleSwift.sharedInstance.authenticateUser(_id, callback: result)
        } else {
            // auth with pin
            print("use pin for auth")
            OneginiModuleSwift.sharedInstance.authenticateUser(nil, callback: result)
        }
    }
    
    func getRegisteredAuthenticators(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        OneginiModuleSwift.sharedInstance.fetchRegisteredAuthenticators(callback: result)
    }
    
    func getAllNotRegisteredAuthenticators(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        OneginiModuleSwift.sharedInstance.fetchNotRegisteredAuthenticator(callback: result)
    }
    
    func acceptPinAuthenticationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard let _arg = call.arguments as! [String: Any]?, let _pin = _arg["pin"] as! String? else { return; }
        OneginiModuleSwift.sharedInstance.submitPinAction(PinFlow.authentication.rawValue, action: PinAction.provide.rawValue, pin: _pin)
    }
    
    func denyPinAuthenticationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        OneginiModuleSwift.sharedInstance.cancelPinAuth()
    }
    
    func logout(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        OneginiModuleSwift.sharedInstance.logOut(callback:result)
    }
    
//    func getIdentityProviders(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
//        OneginiModuleSwift.sharedInstance.identityProviders(callback: result)
//    }
//
//    func getRegisteredAuthenticators(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
//        OneginiModuleSwift.sharedInstance.fetchRegisteredAuthenticators(callback: result)
//    }
//
//    func authenticateWithRegisteredAuthentication(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
//        guard let _arg = call.arguments as! [String: Any]?, let _id = _arg["registeredAuthenticatorsId"] as! String? else { return; }
//        OneginiModuleSwift.sharedInstance.authenticateWithRegisteredAuthentication(_id, callback: result)
//    }
//
//    func singleSignOn(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
//        guard let _arg = call.arguments as! [String: Any]?, let _path = _arg["url"] as! String? else { return; }
//        OneginiModuleSwift.sharedInstance.runSingleSignOn(_path, callback: result)
//    }
//
//    func logout(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
//        OneginiModuleSwift.sharedInstance.logOut(callback:result)
//    }
}

