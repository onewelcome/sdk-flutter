import Foundation
import OneginiSDKiOS
import OneginiCrypto
import Flutter

protocol OneginiPluginRegisterProtocol {
    
    func getIdentityProviders(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    
    func registerUser(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    func cancelRegistration(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    
    func acceptPinRegistrationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    func denyPinRegistrationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    
    func deregisterUser(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
}

extension SwiftOneginiPlugin: OneginiPluginRegisterProtocol {
    func getIdentityProviders(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        OneginiModuleSwift.sharedInstance.identityProviders(callback: result)
    }
    
    func registerUser(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard let _arg = call.arguments as! [String: Any]? else { return; }
        let _identifier = _arg["identityProviderId"] as? String
        OneginiModuleSwift.sharedInstance.registerUser(_identifier, callback: result)
    }
    
    func cancelRegistration(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        OneginiModuleSwift.sharedInstance.cancelRegistration()
    }
    
    func acceptPinRegistrationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard let _arg = call.arguments as! [String: Any]?, let _pin = _arg["pin"] as! String? else { return; }
        //guard let isCustomAuth = _arg["isCustomAuth"] else {}
        
        OneginiModuleSwift.sharedInstance.submitPinAction(PinFlow.create.rawValue, action: PinAction.provide.rawValue, pin: _pin)
    }
    
    func denyPinRegistrationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        OneginiModuleSwift.sharedInstance.cancelPinAuth()
    }
    
    func deregisterUser(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        OneginiModuleSwift.sharedInstance.deregisterUser(callback:result)
    }
    
//    func registration(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
//        OneginiModuleSwift.sharedInstance.registerUser(nil, callback: result)
//    }
//
//    func registrationWithIdentityProvider(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
//        guard let _arg = call.arguments as! [String: String]?, let _identifier = _arg["identityProviderId"] else { return; }
//
//        OneginiModuleSwift.sharedInstance.registerUser(_identifier, callback: result)
//    }
//
//    func cancelRegistration(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
//        OneginiModuleSwift.sharedInstance.cancelRegistration()
//    }
//
//    func deregisterUser(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
//        OneginiModuleSwift.sharedInstance.deregisterUser(callback:result)
//    }
//
//    func registerFingerprintAuthenticator(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
//        OneginiModuleSwift.sharedInstance.registerFingerprintAuthenticator(callback: result)
//    }
//
//    func isUserNotRegisteredFingerprint(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
//        OneginiModuleSwift.sharedInstance.fetchNotRegisteredAuthenticator(callback: result)
//    }
}

