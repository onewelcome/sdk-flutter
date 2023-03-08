import Foundation
import OneginiSDKiOS
import Flutter

protocol OneginiPluginAuthProtocol {

    func authenticateUserImplicitly(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    func denyPinAuthenticationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void

}

//MARK: - OneginiPluginAuthProtocol
extension SwiftOneginiPlugin: OneginiPluginAuthProtocol {

    func authenticateUserImplicitly(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard let arg = call.arguments as? [String: Any] else {
            result(SdkError(.methodArgumentNotFound).flutterError())
            return
        }

        guard let profileId = arg["profileId"] as? String else {
            result(SdkError(.methodArgumentNotFound).flutterError())
            return
        }

        let scopes = arg["scopes"] as? [String]

        OneginiModuleSwift.sharedInstance.authenticateUserImplicitly(profileId, scopes, result)
    }

    func authenticateDevice(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard let _arg = call.arguments as! [String: Any]? else { return }
        let _scopes = _arg["scope"] as? [String]
        OneginiModuleSwift.sharedInstance.authenticateDevice(_scopes, callback: result)
    }

    func denyPinAuthenticationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        OneginiModuleSwift.sharedInstance.cancelPinAuth()
    }
}
