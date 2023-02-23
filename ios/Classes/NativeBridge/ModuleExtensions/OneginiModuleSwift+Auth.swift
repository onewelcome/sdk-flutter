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
        bridgeConnector.toLogoutUserHandler.logout { (error) in
            error != nil ? callback(error?.flutterError()) : callback(true)
        }
    }
    
    func authenticateUser(_ profileId: String?,
                          callback: @escaping FlutterResult) -> Void {
        
        guard let profile: ONGUserProfile = ONGClient.sharedInstance().userClient.userProfiles().first else
        {
            callback(SdkError.convertToFlutter(SdkError(.userProfileDoesNotExist)))
            return
        }

        bridgeConnector.toLoginHandler.authenticateUser(profile, authenticator: nil, completion: {
            (userProfile, error) -> Void in

            if let _userProfile = userProfile {
                var result = Dictionary<String, Any?>()
                result[Constants.Keys.userProfile] = [Constants.Keys.profileId: _userProfile.profileId]
                
                callback(String.stringify(json: result))
            } else {
                callback(SdkError.convertToFlutter(error))
            }
        })
    }
    
    public func authenticateUserImplicitly(_ profileId: String, _ scopes: [String]?,
                                           _ callback: @escaping FlutterResult) {
        guard let profile: ONGUserProfile = ONGClient.sharedInstance().userClient.userProfiles().first(where: { $0.profileId == profileId }) else {
            callback(SdkError(.userProfileDoesNotExist).flutterError())
            return
        }

        bridgeConnector.toResourceFetchHandler.authenticateUserImplicitly(profile, scopes: scopes, completion: {
            (result) -> Void in
            switch result {
            case .success(let response):
                callback(response)
            case .failure(let error):
                callback(error.flutterError())
            }
        })
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
    
    func authenticateWithRegisteredAuthentication(_ identifierId: String?, callback: @escaping FlutterResult) {
        guard let _identifierId = identifierId else {
            callback(SdkError.convertToFlutter(SdkError(.authenticatorIdIsNull)))
            return
        }
        guard let profile: ONGUserProfile = ONGClient.sharedInstance().userClient.userProfiles().first else
        {
            callback(SdkError.convertToFlutter(SdkError(.userProfileDoesNotExist)))
            return
        }
        
        let registeredAuthenticator = Array(ONGUserClient.sharedInstance().registeredAuthenticators(forUser: profile)).first(where: { $0.identifier == identifierId })
        
        // Preferred Authenticator
        bridgeConnector.toAuthenticatorsHandler.setPreferredAuthenticator(profile, _identifierId) { [weak self] (value, error) in
            
            guard error == nil else { callback(SdkError.convertToFlutter(error))
                return
            }
            
            self?.bridgeConnector.toLoginHandler.authenticateUser(profile, authenticator: registeredAuthenticator, completion: {
                (userProfile, error) -> Void in
                if let _userProfile = userProfile {
                    var result = Dictionary<String, Any?>()
                    result[Constants.Keys.userProfile] = [Constants.Keys.profileId: _userProfile.profileId]
                    
                    callback(String.stringify(json: result))
                } else {
                    callback(SdkError.convertToFlutter(error))
                }
            })
        }
    }
    
    func setPreferredAuthenticator(_ identifierId: String?, callback: @escaping FlutterResult) {
        guard let _identifierId = identifierId else {
            callback(SdkError.convertToFlutter(SdkError(.authenticatorIdIsNull)))
            return
        }
        guard let profile: ONGUserProfile = ONGClient.sharedInstance().userClient.userProfiles().first else
        {
            callback(SdkError.convertToFlutter(SdkError(.userProfileDoesNotExist)))
            return
        }
        
        // Preferred Authenticator
        bridgeConnector.toAuthenticatorsHandler.setPreferredAuthenticator(profile, _identifierId) { (value, error) in
            
            guard error == nil else { callback(SdkError.convertToFlutter(error))
                return
            }
            
            callback(value)
        }
    }
    
    func deregisterAuthenticator(_ identifierId: String?, callback: @escaping FlutterResult) {
        guard let _identifierId = identifierId else {
            callback(SdkError.convertToFlutter(SdkError(.authenticatorIdIsNull)))
            return
        }
        guard let profile: ONGUserProfile = ONGClient.sharedInstance().userClient.userProfiles().first else
        {
            callback(SdkError.convertToFlutter(SdkError(.userProfileDoesNotExist)))
            return
        }
        
        // DeregisterA Authenticator
        bridgeConnector.toAuthenticatorsHandler.deregisterAuthenticator(profile, _identifierId) { (value, error) in
            
            guard error == nil else { callback(SdkError.convertToFlutter(error))
                return
            }
            
            callback(value)
        }
    }
    
    func getAuthenticatedUserProfile(callback: @escaping FlutterResult) {
        guard let profile = ONGUserClient.sharedInstance().authenticatedUserProfile() else {
            callback(SdkError.convertToFlutter(SdkError(.authenticatedUserProfileIsNull)))
            return
        }
        callback(String.stringify(json: ["profileId": profile.profileId]))
    }
    
    func getAccessToken(callback: @escaping FlutterResult) {
        guard let accessToken = ONGUserClient.sharedInstance().accessToken else {
            callback(SdkError.convertToFlutter(SdkError(.authenticatedUserProfileIsNull)))
            return
        }
        callback(accessToken)
    }
}

