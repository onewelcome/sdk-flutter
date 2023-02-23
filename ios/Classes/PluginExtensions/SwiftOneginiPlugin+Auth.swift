import Foundation
import OneginiSDKiOS
import OneginiCrypto
import Flutter

protocol OneginiPluginAuthProtocol {

    func registerAuthenticator(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    func authenticateUser(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    func authenticateUserImplicitly(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void

    func getRegisteredAuthenticators(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    func getAllNotRegisteredAuthenticators(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    func getAllAuthenticators(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    func setPreferredAuthenticator(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)

    func acceptPinAuthenticationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    func denyPinAuthenticationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    func deregisterAuthenticator(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void

    func logout(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void

}

//MARK: - OneginiPluginAuthProtocol
extension SwiftOneginiPlugin: OneginiPluginAuthProtocol {
    func registerAuthenticator(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard let _arg = call.arguments as! [String: Any]?, let _authenticator = _arg["authenticatorId"] as! String? else {
            result(SdkError(.emptyInputValue).flutterError())
            return
        }
        OneginiModuleSwift.sharedInstance.registerAuthenticator(_authenticator, callback: result)
    }

    func authenticateUser(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard let _arg = call.arguments as! [String: Any]? else { return; }
        let _id = _arg["registeredAuthenticatorId"] as? String
        if (_id != nil) {
            // auth with provider
            Logger.log("use provider for auth")
            OneginiModuleSwift.sharedInstance.authenticateWithRegisteredAuthentication(_id, callback: result)
        } else {
            // auth with pin
            Logger.log("use pin for auth")
            OneginiModuleSwift.sharedInstance.authenticateUser(nil, callback: result)
        }
    }

    func authenticateUserImplicitly(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard let arg = call.arguments as? [String: Any] else {
            result(SdkError(.mappedMethodArgumentIsMissing).flutterError());
            return;
        }

        guard let profileId = arg["profileId"] as? String else {
            result(SdkError(.mappedMethodArgumentIsMissing).flutterError());
            return;
        }

        let scopes = arg["scopes"] as? [String]

        OneginiModuleSwift.sharedInstance.authenticateUserImplicitly(profileId, scopes, result)
    }

    func authenticateDevice(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard let _arg = call.arguments as! [String: Any]? else { return }
        let _scopes = _arg["scope"] as? [String]
        OneginiModuleSwift.sharedInstance.authenticateDevice(_scopes, callback: result)
    }

    func getRegisteredAuthenticators(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        OneginiModuleSwift.sharedInstance.fetchRegisteredAuthenticators(callback: result)
    }

    func getAllNotRegisteredAuthenticators(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        OneginiModuleSwift.sharedInstance.fetchNotRegisteredAuthenticator(callback: result)
    }

    func getAllAuthenticators(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        OneginiModuleSwift.sharedInstance.fetchAllAuthenticators(callback: result)
    }

    func setPreferredAuthenticator(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard let _arg = call.arguments as! [String: Any]? else { return; }
        let _id = _arg["authenticatorId"] as? String

        OneginiModuleSwift.sharedInstance.setPreferredAuthenticator(_id, callback: result)
    }

    func deregisterAuthenticator(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void {
        guard let _arg = call.arguments as! [String: Any]? else { return }
        let _id = _arg["authenticatorId"] as? String

        OneginiModuleSwift.sharedInstance.deregisterAuthenticator(_id, callback: result)
    }

    func acceptPinAuthenticationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard let _arg = call.arguments as! [String: Any]?, let _pin = _arg["pin"] as! String? else {
            result(SdkError(.emptyInputValue).flutterError())
            return
        }
        OneginiModuleSwift.sharedInstance.submitPinAction(PinFlow.authentication.rawValue, action: PinAction.provide.rawValue, pin: _pin)
    }

    func validatePinWithPolicy(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard let _arg = call.arguments as! [String: Any]?, let _pin = _arg["pin"] as! String? else {
            result(SdkError(.emptyInputValue).flutterError())
            return;
        }
        OneginiModuleSwift.sharedInstance.validatePinWithPolicy(_pin, callback: result)
    }

    func denyPinAuthenticationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        OneginiModuleSwift.sharedInstance.cancelPinAuth()
    }

    func logout(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        OneginiModuleSwift.sharedInstance.logOut(callback:result)
    }
    
    func getAuthenticatedUserProfile(_ result: @escaping FlutterResult) {
        OneginiModuleSwift.sharedInstance.getAuthenticatedUserProfile(callback: result)
    }
    
    func getAccessToken(_ result: @escaping FlutterResult) {
        OneginiModuleSwift.sharedInstance.getAccessToken(callback: result)
    }
}
