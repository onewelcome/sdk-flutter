import Foundation
import OneginiSDKiOS
import OneginiCrypto
import Flutter

extension OneginiModuleSwift {

    func identityProviders(callback: @escaping FlutterResult) {
        let _providers = ONGClient.sharedInstance().userClient.identityProviders()
        let jsonData = _providers.compactMap { (identityProvider) -> [String: Any]? in
            var data = [String: Any]()
            data["id"] = identityProvider.identifier
            data["name"] = identityProvider.name
            return data
        }

        let data = String.stringify(json: jsonData)
        callback(data)
    }

    func logOut(callback: @escaping FlutterResult) {
        bridgeConnector.toLogoutUserHandler.logout { error in
            error != nil ? callback(error?.flutterError()) : callback(true)
        }
    }

    func authenticateUserPin(_ profileId: String, completion: @escaping FlutterResult) -> Void {
        guard let profile = ONGClient.sharedInstance().userClient.userProfiles().first(where: { $0.profileId == profileId }) else {
            completion(SdkError(.noUserProfileIsAuthenticated).flutterError())
            return
        }

        bridgeConnector.toLoginHandler.authenticateUser(profile, authenticator: nil, completion: {
            (userProfile, error) -> Void in
            guard let userProfile = userProfile else {
                completion(SdkError.convertToFlutter(error))
                return
            }

            completion(String.stringify(json: [Constants.Keys.userProfile: [Constants.Keys.profileId: userProfile.profileId]]))
        })
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

    func runSingleSignOn(_ path: String?, callback: @escaping FlutterResult) -> Void {
        
        guard let _path = path, let _url = URL(string: _path) else {
            callback(SdkError(.providedUrlIncorrect))
            return
        }
        
        bridgeConnector.toAppToWebHandler.signInAppToWeb(targetURL: _url, completion: { (result, error) in
            error != nil ? callback(SdkError.convertToFlutter(error)) : callback(String.stringify(json: result ?? []))
        })
    }

    func authenticateWithRegisteredAuthentication(profileId: String, registeredAuthenticatorId: String, completion: @escaping FlutterResult) {
        guard let profile = ONGClient.sharedInstance().userClient.userProfiles().first(where: { $0.profileId == profileId }) else {
            completion(SdkError(.noUserProfileIsAuthenticated).flutterError())
            return
        }

        guard let registeredAuthenticator = ONGUserClient.sharedInstance().registeredAuthenticators(forUser: profile).first(where: { $0.identifier == registeredAuthenticatorId }) else {
            completion(SdkError(.authenticatorNotFound).flutterError())
            return
        }

        bridgeConnector.toLoginHandler.authenticateUser(profile, authenticator: registeredAuthenticator) {
            (userProfile, error) -> Void in
            guard let userProfile = userProfile else {
                completion(SdkError.convertToFlutter(error))
                return
            }

            completion(String.stringify(json: [Constants.Keys.userProfile: [Constants.Keys.profileId: userProfile.profileId]]))
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
                completion(SdkError.convertToFlutter(error))
                return
            }

            completion(value)
        }
    }

    func getAuthenticatedUserProfile(callback: @escaping FlutterResult) {
        guard let profile = ONGUserClient.sharedInstance().authenticatedUserProfile() else {
            callback(SdkError.convertToFlutter(SdkError(.noUserProfileIsAuthenticated)))
            return
        }
        callback(String.stringify(json: ["profileId": profile.profileId]))
    }
}
