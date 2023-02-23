import Foundation
import OneginiSDKiOS
import Flutter

protocol OneginiPluginBaseProtocol {
    func startApp(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
}

extension SwiftOneginiPlugin: OneginiPluginBaseProtocol {
    func startApp(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard let _arg = call.arguments as! [String: Any]?,
              let _connectionTimeout = _arg["connectionTimeout"] as? Int
        else { return; }
        
        let timeInterval = TimeInterval(_connectionTimeout);
        ONGClientBuilder().setHttpRequestTimeout(timeInterval)
        OneginiModuleSwift.sharedInstance.startOneginiModule(callback: result)
    }
}

