import Foundation
import OneginiSDKiOS
import Flutter

extension OneginiModuleSwift {

    func getIdentityProviders() -> Result<[OWIdentityProvider], FlutterError> {
        let providers = ONGClient.sharedInstance().userClient.identityProviders()
        return .success(providers.compactMap({OWIdentityProvider($0)}))
    }

    func logOut(callback: @escaping (Result<Void, FlutterError>) -> Void) {
        bridgeConnector.toLogoutUserHandler.logout(completion: callback)
    }

    public func authenticateUserImplicitly(_ profileId: String, _ scopes: [String]?,
                                           _ completion: @escaping FlutterResult) {
        guard let profile = ONGClient.sharedInstance().userClient.userProfiles().first(where: { $0.profileId == profileId }) else {
            completion(SdkError(.noUserProfileIsAuthenticated).flutterError())
            return
        }

        bridgeConnector.toResourceFetchHandler.authenticateUserImplicitly(profile, scopes: scopes) {
            result -> Void in
            switch result {
            case .success(let response):
                completion(response)
            case .failure(let error):
                completion(error.flutterError())
            }
        }
    }

    func runSingleSignOn(_ path: String, completion: @escaping (Result<OWAppToWebSingleSignOn, Error>) -> Void) {
        
        guard let url = URL(string: path) else {
            completion(.failure(FlutterError(.providedUrlIncorrect)))
            return
        }
        bridgeConnector.toAppToWebHandler.signInAppToWeb(targetURL: url, completion: completion)
    }
    
    func authenticateUser(profileId: String, authenticatorId: String?, completion: @escaping (Result<OWRegistrationResponse, FlutterError>) -> Void) {
        
        guard let profile = ONGClient.sharedInstance().userClient.userProfiles().first(where: { $0.profileId == profileId }) else {
            completion(.failure(SdkError(.userProfileDoesNotExist).flutterError()))
            return
        }
        
        let authenticator = ONGUserClient.sharedInstance().registeredAuthenticators(forUser: profile).first(where: { $0.identifier == authenticatorId })
        
        bridgeConnector.toLoginHandler.authenticateUser(profile, authenticator: authenticator) { result in
            completion(result)
        }
        
    }

    func setPreferredAuthenticator(_ identifierId: String, completion: @escaping FlutterResult) {
        guard let profile = ONGClient.sharedInstance().userClient.authenticatedUserProfile() else {
            completion(SdkError.convertToFlutter(SdkError(.noUserProfileIsAuthenticated)))
            return
        }

        // Preferred Authenticator
        bridgeConnector.toAuthenticatorsHandler.setPreferredAuthenticator(profile, identifierId) { value, error in
            guard error == nil else {
                completion(SdkError.convertToFlutter(error))
                return
            }

            completion(value)
        }
    }
    
    func deregisterAuthenticator(_ identifierId: String, completion: @escaping FlutterResult) {
        guard let profile = ONGClient.sharedInstance().userClient.authenticatedUserProfile() else {
            completion(SdkError.convertToFlutter(SdkError(.noUserProfileIsAuthenticated)))
            return
        }

        // Deregister Authenticator
        bridgeConnector.toAuthenticatorsHandler.deregisterAuthenticator(profile, identifierId) { value, error in
            guard error == nil else {
                // FIXME: use Result and make this FlutterError
                completion(SdkError.convertToFlutter(error))
                return
            }

            completion(value)
        }
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
