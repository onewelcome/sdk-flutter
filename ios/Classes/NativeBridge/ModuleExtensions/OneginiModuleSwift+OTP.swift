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

    func enrollMobileAuthenticationWithPush(token: String, completion: @escaping (Result<Void, FlutterError>) -> Void) {
        bridgeConnector.toMobileAuthHandler.enrollMobileAuthenticationWithPush(token: token, completion: completion)
    }

    func isUserEnrolledForMobileAuthWithPush(profileId: String, completion: @escaping (Result<Void, FlutterError>) -> Void) {
        guard let profile = SharedUserClient.instance.userProfiles.first(where: { $0.profileId == profileId }) else {
            completion(.failure(SdkError(.notFoundUserProfile).flutterError()))
            return
        }
        bridgeConnector.toMobileAuthHandler.isUserEnrolledForMobileAuthWithPush(profile: profile, completion: completion)
    }

    func denyMobileAuthWithPushRequest(request: OWMobileAuthWithPushRequest, completion: @escaping (Result<Void, FlutterError>) -> Void) {
        bridgeConnector.toMobileAuthHandler.denyMobileAuthWithPushRequest(request: request, completion: completion)
    }

    func acceptMobileAuthWithPushRequest(request: OWMobileAuthWithPushRequest, completion: @escaping (Result<Void, FlutterError>) -> Void) {
        bridgeConnector.toMobileAuthHandler.acceptMobileAuthWithPushRequest(request: request, completion: completion)
    }

    func getPendingMobileAuthWithPushRequests(completion: @escaping (Result<[OWMobileAuthWithPushRequest], FlutterError>) -> Void) {
        bridgeConnector.toMobileAuthHandler.getPendingMobileAuthWithPushRequests(completion: completion)
    }

    func acceptMobileAuthRequest(completion: @escaping (Result<Void, FlutterError>) -> Void) {
        bridgeConnector.toMobileAuthHandler.acceptMobileAuthRequest(completion: completion)
    }

    func denyMobileAuthRequest(completion: @escaping (Result<Void, FlutterError>) -> Void) {
        bridgeConnector.toMobileAuthHandler.denyMobileAuthRequest(completion: completion)
    }
}
