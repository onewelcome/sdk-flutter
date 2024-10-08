import Foundation
import OneginiSDKiOS
import Flutter

extension OneginiModuleSwift {

    func getIdentityProviders() -> Result<[OWIdentityProvider], FlutterError> {
        let providers = SharedClient.instance.userClient.identityProviders
        return .success(providers.compactMap { OWIdentityProvider(id: $0.identifier, name: $0.name) })
    }

    func logOut(callback: @escaping (Result<Void, FlutterError>) -> Void) {
        bridgeConnector.toLogoutUserHandler.logout(completion: callback)
    }

    public func authenticateUserImplicitly(_ profileId: String, _ scopes: [String]?,
                                           completion: @escaping (Result<Void, FlutterError>) -> Void) {
        guard let profile = SharedUserClient.instance.userProfiles.first(where: { $0.profileId == profileId }) else {
            completion(.failure(SdkError(.notFoundUserProfile).flutterError()))
            return
        }

        bridgeConnector.toResourceFetchHandler.authenticateUserImplicitly(profile, scopes: scopes, completion: completion)
    }

    func runSingleSignOn(_ path: String, completion: @escaping (Result<OWAppToWebSingleSignOn, FlutterError>) -> Void) {

        guard let url = URL(string: path) else {
            completion(.failure(FlutterError(.invalidUrl)))
            return
        }
        bridgeConnector.toAppToWebHandler.signInAppToWeb(targetURL: url, completion: completion)
    }

    func authenticateUser(profileId: String, authenticatorType: AuthenticatorType?, completion: @escaping (Result<OWRegistrationResponse, FlutterError>) -> Void) {

        guard let profile = SharedUserClient.instance.userProfiles.first(where: { $0.profileId == profileId }) else {
            completion(.failure(SdkError(.notFoundUserProfile).flutterError()))
            return
        }
        let authenticator = SharedUserClient.instance.authenticators(.registered, for: profile).first(where: { $0.type == authenticatorType })

        bridgeConnector.toLoginHandler.authenticateUser(profile, authenticator: authenticator) { result in
            completion(result)
        }
    }

    func setPreferredAuthenticator(_ authenticatorType: AuthenticatorType, completion: @escaping (Result<Void, FlutterError>) -> Void) {
        guard let profile = SharedUserClient.instance.authenticatedUserProfile else {
            completion(.failure(FlutterError(.notAuthenticatedUser)))
            return
        }
        bridgeConnector.toAuthenticatorsHandler.setPreferredAuthenticator(profile, authenticatorType, completion)
    }

    func deregisterBiometricAuthenticator(completion: @escaping (Result<Void, FlutterError>) -> Void) {
        guard let profile = SharedUserClient.instance.authenticatedUserProfile else {
            completion(.failure(FlutterError(.notAuthenticatedUser)))
            return
        }
        bridgeConnector.toAuthenticatorsHandler.deregisterBiometricAuthenticator(profile, completion)
    }

    func registerBiometricAuthenticator(completion: @escaping (Result<Void, FlutterError>) -> Void) {
        guard let profile = SharedUserClient.instance.authenticatedUserProfile else {
            completion(.failure(FlutterError(.notAuthenticatedUser)))
            return
        }
        bridgeConnector.toAuthenticatorsHandler.registerBiometricAuthenticator(profile, completion)
    }

    func getBiometricAuthenticator(profileId: String, completion: @escaping (Result<OWAuthenticator, Error>) -> Void) {
        guard let profile = SharedUserClient.instance.userProfiles.first(where: {$0.profileId == profileId }) else {
            completion(.failure(FlutterError(.notFoundUserProfile)))
            return
        }
        bridgeConnector.toAuthenticatorsHandler.getBiometricAuthenticator(profile, completion: completion)
    }

    func getPreferredAuthenticator(profileId: String, completion: @escaping (Result<OWAuthenticator, Error>) -> Void) {
        guard let profile = SharedUserClient.instance.userProfiles.first(where: {$0.profileId == profileId }) else {
            completion(.failure(FlutterError(.notFoundUserProfile)))
            return
        }
        bridgeConnector.toAuthenticatorsHandler.getPreferredAuthenticator(profile, completion: completion)
    }

    func getAuthenticatedUserProfile() -> Result<OWUserProfile, FlutterError> {
        guard let profile = SharedUserClient.instance.authenticatedUserProfile else {
            return .failure(FlutterError(.notAuthenticatedUser))
        }
        return .success(OWUserProfile(profile))
    }

    func getAccessToken() -> Result<String, FlutterError> {
        guard let accessToken = SharedUserClient.instance.accessToken else {
            return .failure(FlutterError(.notAuthenticatedUser))
        }
        return .success(accessToken)
    }
}
