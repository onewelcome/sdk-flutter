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
        print("[NOT IMPLEMENTED] handleMobileAuthWithOtp")
    }
    
    func acceptOtpAuthenticationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        print("[NOT IMPLEMENTED] acceptOtpAuthenticationRequest")
    }
    
    func denyOtpAuthenticationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        print("[NOT IMPLEMENTED] denyOtpAuthenticationRequest")
    }
}

