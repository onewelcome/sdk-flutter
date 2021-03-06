import Foundation
import OneginiSDKiOS
import OneginiCrypto
import Flutter

protocol OneginiPluginOtherProtocol {
    func changePin(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    func getAppToWebSingleSignOn(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    func fetchUserProfiles(_ result: @escaping FlutterResult) -> Void
}

extension SwiftOneginiPlugin: OneginiPluginOtherProtocol {
    func changePin(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        OneginiModuleSwift.sharedInstance.changePin(callback: result)
    }
    
    func getAppToWebSingleSignOn(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard let _arg = call.arguments as! [String: Any]?, let _path = _arg["url"] as! String? else { return; }
        OneginiModuleSwift.sharedInstance.runSingleSignOn(_path, callback: result)
    }
    
    func fetchUserProfiles(_ result: @escaping FlutterResult) {
        OneginiModuleSwift.sharedInstance.fetchUserProfiles(callback: result)
    }
}

