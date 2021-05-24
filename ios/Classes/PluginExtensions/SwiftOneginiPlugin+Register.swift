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
    func cancelRegistration(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    
    func acceptPinRegistrationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    func denyPinRegistrationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    
    func customTwoStepRegistrationReturnSuccess(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    func customTwoStepRegistrationReturnError(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    
    func deregisterUser(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
}

extension SwiftOneginiPlugin: OneginiPluginRegisterProtocol {
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
    }
    
    func cancelRegistration(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        OneginiModuleSwift.sharedInstance.cancelRegistration()
    }
    
    func acceptPinRegistrationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard let _arg = call.arguments as! [String: Any]?, let _pin = _arg["pin"] as! String? else { return; }
        
        OneginiModuleSwift.sharedInstance.submitPinAction(PinFlow.create.rawValue, action: PinAction.provide.rawValue, pin: _pin)
    }
    
    func denyPinRegistrationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        OneginiModuleSwift.sharedInstance.cancelPinAuth()
    }
    
    func customTwoStepRegistrationReturnSuccess(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard let _arg = call.arguments as! [String: Any]?, let _data = _arg["data"] as! String? else { return; }
        OneginiModuleSwift.sharedInstance.handleTwoStepRegistration(_data)
    }
    
    func customTwoStepRegistrationReturnError(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard let _arg = call.arguments as! [String: Any]?, let _error = _arg["error"] as! String? else { return; }
        OneginiModuleSwift.sharedInstance.cancelTwoStepRegistration(_error)
    }
    
    func deregisterUser(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        OneginiModuleSwift.sharedInstance.deregisterUser(callback:result)
    }
}

