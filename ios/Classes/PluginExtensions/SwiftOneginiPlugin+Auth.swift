import Foundation
import OneginiSDKiOS
import OneginiCrypto
import Flutter

protocol OneginiPluginAuthProtocol {
    func getIdentityProviders(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    func getRegisteredAuthenticators(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    func authenticateWithRegisteredAuthentication(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    func singleSignOn(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    func logOut(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
}

extension SwiftOneginiPlugin: OneginiPluginAuthProtocol {
    func getIdentityProviders(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        OneginiModuleSwift.sharedInstance.identityProviders(callback: result)
    }
    
    func getRegisteredAuthenticators(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        OneginiModuleSwift.sharedInstance.fetchRegisteredAuthenticators(callback: result)
    }
    
    func authenticateWithRegisteredAuthentication(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard let _arg = call.arguments as! [String: Any]?, let _id = _arg["registeredAuthenticatorsId"] as! String? else { return; }
        OneginiModuleSwift.sharedInstance.authenticateWithRegisteredAuthentication(_id, callback: result)
    }
    
    func singleSignOn(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard let _arg = call.arguments as! [String: Any]?, let _path = _arg["url"] as! String? else { return; }
        OneginiModuleSwift.sharedInstance.runSingleSignOn(_path, callback: result)
    }
    
    func logOut(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        OneginiModuleSwift.sharedInstance.logOut(callback:result)
    }
}

