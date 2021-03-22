import Foundation
import OneginiSDKiOS
import OneginiCrypto
import Flutter

protocol OneginiPluginOtpProtocol {
    func handleMobileAuthWithOtp(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    func acceptOtpAuthenticationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    func denyOtpAuthenticationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
}

extension SwiftOneginiPlugin: OneginiPluginOtpProtocol {
    func handleMobileAuthWithOtp(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard let _arg = call.arguments as! [String: Any]?, let _data = _arg["data"] as! String? else { return }
        
        OneginiModuleSwift.sharedInstance.otpQRResourceCodeConfirmation(code: _data, callback: result)
    }
    
    func acceptOtpAuthenticationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        OneginiModuleSwift.sharedInstance.acceptMobileAuthConfirmation(callback: result)
    }
    
    func denyOtpAuthenticationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        //print("[NOT IMPLEMENTED] denyOtpAuthenticationRequest")
        OneginiModuleSwift.sharedInstance.denyMobileAuthConfirmation(callback: result)
    }
}

