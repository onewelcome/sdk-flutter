import Foundation
import OneginiSDKiOS
import Flutter

extension OneginiModuleSwift {

    func getIdentityProviders() -> Result<[OWIdentityProvider], FlutterError> {
        let providers = ONGClient.sharedInstance().userClient.identityProviders()
        return .success(providers.compactMap { OWIdentityProvider($0) })
    }

    func logOut(callback: @escaping (Result<Void, FlutterError>) -> Void) {
        bridgeConnector.toLogoutUserHandler.logout(completion: callback)
    }

    public func authenticateUserImplicitly(_ profileId: String, _ scopes: [String]?,
                                           completion: @escaping (Result<Void, FlutterError>) -> Void) {
        guard let profile = SharedUserClient.instance.userProfiles.first(where: { $0.profileId == profileId }) else {
            completion(.failure(SdkError(.userProfileDoesNotExist).flutterError()))
            return
        }

        bridgeConnector.toResourceFetchHandler.authenticateUserImplicitly(profile, scopes: scopes, completion: completion)
    }

    func runSingleSignOn(_ path: String, completion: @escaping (Result<OWAppToWebSingleSignOn, FlutterError>) -> Void) {

        guard let url = URL(string: path) else {
            completion(.failure(FlutterError(.providedUrlIncorrect)))
            return
        }
        bridgeConnector.toAppToWebHandler.signInAppToWeb(targetURL: url, completion: completion)
    }

    func authenticateUser(profileId: String, authenticatorType: AuthenticatorType?, completion: @escaping (Result<OWRegistrationResponse, FlutterError>) -> Void) {

        guard let profile = SharedUserClient.instance.userProfiles.first(where: { $0.profileId == profileId }) else {
            completion(.failure(SdkError(.userProfileDoesNotExist).flutterError()))
            return
        }
        let authenticator = SharedUserClient.instance.authenticators(.all, for: profile).first(where: { $0.type == authenticatorType })

        bridgeConnector.toLoginHandler.authenticateUser(profile, authenticator: authenticator) { result in
            completion(result)
        }
    }

    func setPreferredAuthenticator(_ authenticatorType: AuthenticatorType, completion: @escaping (Result<Void, FlutterError>) -> Void) {
        guard let profile = SharedUserClient.instance.authenticatedUserProfile else {
            completion(.failure(FlutterError(.noUserProfileIsAuthenticated)))
            return
        }
        bridgeConnector.toAuthenticatorsHandler.setPreferredAuthenticator(profile, authenticatorType, completion)
    }

    func deregisterBiometricAuthenticator(completion: @escaping (Result<Void, FlutterError>) -> Void) {
        guard let profile = SharedUserClient.instance.authenticatedUserProfile else {
            completion(.failure(FlutterError(.noUserProfileIsAuthenticated)))
            return
        }
        bridgeConnector.toAuthenticatorsHandler.deregisterBiometricAuthenticator(profile, completion)
    }

    func registerBiometricAuthenticator(completion: @escaping (Result<Void, FlutterError>) -> Void) {
        guard let profile = SharedUserClient.instance.authenticatedUserProfile else {
            completion(.failure(FlutterError(.noUserProfileIsAuthenticated)))
            return
        }
        bridgeConnector.toAuthenticatorsHandler.registerBiometricAuthenticator(profile, completion)
    }

    func getBiometricAuthenticator(profileId: String, completion: @escaping (Result<OWAuthenticator, Error>) -> Void) {
        guard let profile = SharedUserClient.instance.userProfiles.first(where: {$0.profileId == profileId }) else {
            completion(.failure(FlutterError(.userProfileDoesNotExist)))
            return
        }
        bridgeConnector.toAuthenticatorsHandler.getBiometricAuthenticator(profile, completion: completion)
    }

    func getPreferredAuthenticator(profileId: String, completion: @escaping (Result<OWAuthenticator, Error>) -> Void) {
        guard let profile = SharedUserClient.instance.userProfiles.first(where: {$0.profileId == profileId }) else {
            completion(.failure(FlutterError(.userProfileDoesNotExist)))
            return
        }
        bridgeConnector.toAuthenticatorsHandler.getPreferredAuthenticator(profile, completion: completion)
    }

    func getAuthenticatedUserProfile() -> Result<OWUserProfile, FlutterError> {
        guard let profile = ONGUserClient.sharedInstance().authenticatedUserProfile() else {
            return .failure(FlutterError(.noUserProfileIsAuthenticated))
        }
        return .success(OWUserProfile(profile))
    }

    func getAccessToken() -> Result<String, FlutterError> {
        guard let accessToken = ONGUserClient.sharedInstance().accessToken else {
            return .failure(FlutterError(.noUserProfileIsAuthenticated))
        }
        return .success(accessToken)
    }
}
