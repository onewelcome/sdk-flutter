import Foundation
import OneginiSDKiOS
import OneginiCrypto
import Flutter

protocol OneginiPluginRegisterProtocol {
    func registration(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    func registrationWithIdentityProvider(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    func cancelRegistration(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    func deregisterUser(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    func registerFingerprintAuthenticator(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    func isUserNotRegisteredFingerprint(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
}

extension SwiftOneginiPlugin: OneginiPluginRegisterProtocol {
    func registration(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        OneginiModuleSwift.sharedInstance.registerUser(nil, callback: result)
    }
    
    func registrationWithIdentityProvider(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard let _arg = call.arguments as! [String: String]?, let _identifier = _arg["identityProviderId"] else { return; }

        OneginiModuleSwift.sharedInstance.registerUser(_identifier, callback: result)
    }
    
    func cancelRegistration(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        OneginiModuleSwift.sharedInstance.cancelRegistration()
    }
    
    func deregisterUser(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        OneginiModuleSwift.sharedInstance.deregisterUser(callback:result)
    }
    
    func registerFingerprintAuthenticator(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        OneginiModuleSwift.sharedInstance.registerFingerprintAuthenticator(callback: result)
    }
    
    func isUserNotRegisteredFingerprint(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        OneginiModuleSwift.sharedInstance.fetchNotRegisteredAuthenticator(callback: result)
    }
    
}

