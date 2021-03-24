import Foundation
import OneginiSDKiOS
import OneginiCrypto
import Flutter

protocol OneginiPluginBaseProtocol {
    func startApp(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
}

extension SwiftOneginiPlugin: OneginiPluginBaseProtocol {
    func startApp(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard let _arg = call.arguments as! [String: Any]?,
              let _customIdentityProfiverIds = _arg["twoStepCustomIdentityProviderIds"] as? String,
              let _connectionTimeout = _arg["connectionTimeout"] as? Int/*,
              let _readTimeout = _arg["readTimeout"] as? Int*/
        else { return; }
        
        print("Providers: " + _customIdentityProfiverIds)
        if (_customIdentityProfiverIds.count > 0) {
            let ids = _customIdentityProfiverIds.split(separator: ",").map {$0.trimmingCharacters(in: .whitespacesAndNewlines)}
                OneginiModuleSwift.sharedInstance.configureCustomRegIdentifiers(ids)
        }
        
        let timeInterval = TimeInterval(_connectionTimeout);
        ONGClientBuilder().setHttpRequestTimeout(timeInterval)
        OneginiModuleSwift.sharedInstance.startOneginiModule(callback: result)
    }
}

