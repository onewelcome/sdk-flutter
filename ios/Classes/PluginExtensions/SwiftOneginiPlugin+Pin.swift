import Foundation
import OneginiSDKiOS
import OneginiCrypto
import Flutter

protocol OneginiPluginPinProtocol {
    func sendPin(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    func pinAuthentication(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    func changePin(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    func cancelPinAuth(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
}

extension SwiftOneginiPlugin: OneginiPluginPinProtocol {
    func sendPin(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard let _arg = call.arguments as! [String: Any]?, let _pin = _arg["pin"] as! String?, let _isAuth = _arg["isAuth"] as! Bool? else { return; }
        
        if (_isAuth) {
            // login
            OneginiModuleSwift.sharedInstance.submitPinAction(PinFlow.authentication.rawValue, action: PinAction.provide.rawValue, pin: _pin)
        } else {
            // register
            OneginiModuleSwift.sharedInstance.submitPinAction(PinFlow.create.rawValue, action: PinAction.provide.rawValue, pin: _pin)
        }
    }
    
    func pinAuthentication(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        OneginiModuleSwift.sharedInstance.authenticateUser(nil, callback: result)
    }
    
    func changePin(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        OneginiModuleSwift.sharedInstance.changePin(callback: result)
    }
    
    func cancelPinAuth(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard let _arg = call.arguments as! [String: Any]?, let _value = _arg["isPin"] as! Bool? else { return; }
        OneginiModuleSwift.sharedInstance.cancelPinAuth(_value)
    }
    
    
}

