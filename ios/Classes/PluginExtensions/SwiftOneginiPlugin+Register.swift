import Foundation
import OneginiSDKiOS
import Flutter



protocol OneginiPluginRegisterProtocol {
    
    func cancelBrowserRegistration(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void

    func submitCustomRegistrationAction(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    func cancelCustomRegistrationAction(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    
}

extension SwiftOneginiPlugin: OneginiPluginRegisterProtocol {

    func cancelBrowserRegistration(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        OneginiModuleSwift.sharedInstance.cancelBrowserRegistration()
    }

    func submitCustomRegistrationAction(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any] else { return; } // FIXME: Throw exception here
        OneginiModuleSwift.sharedInstance.submitCustomRegistrationSuccess(args["data"] as? String)
    }

    func cancelCustomRegistrationAction(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard let _arg = call.arguments as! [String: Any]?, let _error = _arg["error"] as! String? else { return; }
        OneginiModuleSwift.sharedInstance.submitCustomRegistrationError(_error)
    }

}

