import Foundation
import OneginiSDKiOS
import Flutter

extension OneginiModuleSwift {
    func handleMobileAuthWithOtp(_ otp: String, completion: @escaping (Result<Void, FlutterError>) -> Void) {
        bridgeConnector.toMobileAuthHandler.handleMobileAuthWithOtp(otp: otp, completion: completion)
    }

    func enrollMobileAuthentication(completion: @escaping (Result<Void, FlutterError>) -> Void) {
        bridgeConnector.toMobileAuthHandler.enrollMobileAuthentication(completion: completion)
    }

    func acceptMobileAuthRequest(completion: @escaping (Result<Void, FlutterError>) -> Void) {
        bridgeConnector.toMobileAuthHandler.acceptMobileAuthRequest(completion: completion)
    }

    func denyMobileAuthRequest(completion: @escaping (Result<Void, FlutterError>) -> Void) {
        bridgeConnector.toMobileAuthHandler.denyMobileAuthRequest(completion: completion)
    }
}
