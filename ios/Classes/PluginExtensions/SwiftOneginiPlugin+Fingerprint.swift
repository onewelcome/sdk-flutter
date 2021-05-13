import Foundation
import OneginiSDKiOS
import OneginiCrypto
import Flutter

protocol OneginiPluginFingerprintProtocol {
    func acceptFingerprintAuthenticationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    func denyFingerprintAuthenticationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    func fingerprintFallbackToPin(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
}

extension SwiftOneginiPlugin: OneginiPluginFingerprintProtocol {
    func acceptFingerprintAuthenticationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        Logger.log("[NOT IMPLEMENTED] acceptFingerprintAuthenticationRequest")
    }
    
    func denyFingerprintAuthenticationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        Logger.log("[NOT IMPLEMENTED] denyFingerprintAuthenticationRequest")
    }
    
    func fingerprintFallbackToPin(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        Logger.log("[NOT IMPLEMENTED] fingerprintFallbackToPin")
    }
}

