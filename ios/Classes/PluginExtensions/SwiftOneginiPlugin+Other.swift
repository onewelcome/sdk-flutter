import Foundation
import OneginiSDKiOS
import Flutter

protocol OneginiPluginOtherProtocol {
    func getAppToWebSingleSignOn(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
}

extension SwiftOneginiPlugin: OneginiPluginOtherProtocol {
    func getAppToWebSingleSignOn(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard let _arg = call.arguments as! [String: Any]?, let _path = _arg["url"] as! String? else { return; }
        OneginiModuleSwift.sharedInstance.runSingleSignOn(_path, callback: result)
    }
}

