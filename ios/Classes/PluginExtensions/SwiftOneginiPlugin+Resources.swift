import Foundation
import OneginiSDKiOS
import OneginiCrypto
import Flutter

protocol OneginiPluginResouceProtocol {
    func getResource(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
}

extension SwiftOneginiPlugin: OneginiPluginResouceProtocol {
    func getResource(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        handleGetResource(call, result)
    }
    
    private func handleGetResource(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard let _arg = call.arguments as! [String: Any]?, let _path = _arg["path"] as! String? else {
            result(SdkError(.incorrectResourcesAccess).flutterError())
            return
        }
            
        OneginiModuleSwift.sharedInstance.fetchResources(_path, type: call.method, parameters: _arg, callback: result)
    }
}

