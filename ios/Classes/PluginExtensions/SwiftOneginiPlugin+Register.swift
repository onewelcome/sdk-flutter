import Foundation
import OneginiSDKiOS
import Flutter



protocol OneginiPluginRegisterProtocol {

    func cancelCustomRegistrationAction(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    
}

extension SwiftOneginiPlugin: OneginiPluginRegisterProtocol {


    func cancelCustomRegistrationAction(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard let _arg = call.arguments as! [String: Any]?, let _error = _arg["error"] as! String? else { return; }
        OneginiModuleSwift.sharedInstance.submitCustomRegistrationError(_error)
    }

}

