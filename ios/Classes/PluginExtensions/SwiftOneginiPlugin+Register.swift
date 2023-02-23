import Foundation
import OneginiSDKiOS
import OneginiCrypto
import Flutter

enum WebSignInType: Int {
  case insideApp = 0
  case safari
}

protocol OneginiPluginRegisterProtocol {

    func getIdentityProviders(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void

    func registerUser(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    func handleRegisteredProcessUrl(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    
    func cancelBrowserRegistration(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void

    func acceptPinRegistrationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    func denyPinRegistrationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void

    func submitCustomRegistrationAction(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    func cancelCustomRegistrationAction(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void

    func deregisterUser(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    func getRedirectUrl(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    
}

extension SwiftOneginiPlugin: OneginiPluginRegisterProtocol {
    func getRedirectUrl(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        OneginiModuleSwift.sharedInstance.getRedirectUrl(callback: result)
    }
    
    func getIdentityProviders(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        OneginiModuleSwift.sharedInstance.identityProviders(callback: result)
    }

    func registerUser(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard let arg = call.arguments as? [String: Any] else { return; }
        let identifier = arg["identityProviderId"] as? String
        let scopes = arg["scopes"] as? [String]
        OneginiModuleSwift.sharedInstance.registerUser(identifier, scopes: scopes, callback: result)
    }

    func handleRegisteredProcessUrl(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard let arg = call.arguments as? [String: Any] else { return }
        let url = arg["url"] as? String
        let typeValue = arg["type"] as? Int
        
        var type: WebSignInType = .insideApp
        if let _typeValue = typeValue, let value = WebSignInType.init(rawValue: _typeValue) {
            type = value
        }
        OneginiModuleSwift.sharedInstance.handleRegisteredProcessUrl(url ?? "", webSignInType: type)
        result(nil)
    }

    func cancelBrowserRegistration(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        OneginiModuleSwift.sharedInstance.cancelBrowserRegistration()
    }

    func acceptPinRegistrationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard let _arg = call.arguments as! [String: Any]?, let _pin = _arg["pin"] as! String? else { return; }
        
        OneginiModuleSwift.sharedInstance.submitPinAction(PinFlow.create.rawValue, action: PinAction.provide.rawValue, pin: _pin)
    }

    func denyPinRegistrationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        OneginiModuleSwift.sharedInstance.cancelPinAuth()
    }

    func submitCustomRegistrationAction(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard let _arg = call.arguments as! [String: Any]?, let _data = _arg["data"] as! String? else { return; }
        OneginiModuleSwift.sharedInstance.submitCustomRegistrationSuccess(_data)
    }

    func cancelCustomRegistrationAction(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard let _arg = call.arguments as! [String: Any]?, let _error = _arg["error"] as! String? else { return; }
        OneginiModuleSwift.sharedInstance.submitCustomRegistrationError(_error)
    }

    func deregisterUser(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        var profileId: String?
        if let arguments = call.arguments as? [String: Any], let userProfileId = arguments["profileId"] as? String {
            profileId = userProfileId
        }

        OneginiModuleSwift.sharedInstance.deregisterUser(userProfileId: profileId,callback:result)
    }
}

