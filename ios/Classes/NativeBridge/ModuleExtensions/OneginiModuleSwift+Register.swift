import Foundation
import OneginiSDKiOS
import OneginiCrypto
import Flutter

extension OneginiModuleSwift {
    
    func deregisterUser(callback: @escaping FlutterResult) {
        bridgeConnector.toDeregisterUserHandler.disconnect { (error) in
            error != nil ? callback(SdkError.convertToFlutter(error)) : callback(true)
        }
    }
    
    func registerUser(_ identityProviderId: String? = nil, callback: @escaping FlutterResult) -> Void {

        bridgeConnector.toRegistrationConnector.registrationHandler.signUp(identityProviderId) {  (_, userProfile, error) -> Void in

            if let _userProfile = userProfile {
                callback(_userProfile.profileId)
            } else {
                callback(SdkError.convertToFlutter(error))
            }
        }
    }
    
    func handleTwoStepRegistration(_ data: String) {
        bridgeConnector.toRegistrationConnector.registrationHandler.processTwoStepRegistration(data)
    }
    
    func cancelTwoStepRegistration(_ error: String) {
        bridgeConnector.toRegistrationConnector.registrationHandler.cancelTwoStepRegistration(error)
    }
    
    public func cancelRegistration() -> Void {
        bridgeConnector.toRegistrationConnector.registrationHandler.cancelRegistration()
    }
    
    public func cancelCustomRegistration() -> Void {
        bridgeConnector.toRegistrationConnector.registrationHandler.cancelCustomRegistration()
    }
    
    func handleRegistrationCallback(_ url: String) -> Void {
        guard let _url = URL(string: url) else { return }
        
        bridgeConnector.toRegistrationConnector.registrationHandler.processRedirectURL(url: _url)
    }
    
    func registerAuthenticator(_ authenticatorId: String, callback: @escaping FlutterResult) {
        guard let profile = ONGUserClient.sharedInstance().userProfiles().first else {
            callback(SdkError.convertToFlutter(SdkError(customType: .userProfileIsNull)))
            return
        }
        
        let notRegisteredAuthenticators = ONGUserClient.sharedInstance().nonRegisteredAuthenticators(forUser: profile)
              
        let authenticator: ONGAuthenticator? = notRegisteredAuthenticators.first(where: { $0.identifier == authenticatorId })
        
        guard let _ = authenticator else {
            callback(SdkError.convertToFlutter(SdkError.init(customType: .authenticatorNotAvailable)))
            return
        }
        
        bridgeConnector.toAuthenticatorsHandler.registerAuthenticator(profile, authenticator!) {
            (_ , error) -> Void in
            
            if let _error = error {
                callback(SdkError.convertToFlutter(_error))
            } else {
                callback(nil)
            }
        }
    }
    
    func fetchRegisteredAuthenticators(callback: @escaping FlutterResult) {
        guard let profile = ONGUserClient.sharedInstance().userProfiles().first else {
            callback(SdkError.convertToFlutter(SdkError(customType: .userProfileIsNull)))
            return
        }
        
        let registeredAuthenticators = ONGUserClient.sharedInstance().registeredAuthenticators(forUser: profile)
        
        let authenticators: [[String: String]] = registeredAuthenticators.compactMap({ ["id" : $0.identifier, "name": $0.name] })
        
        let data = String.stringify(json: authenticators)
        callback(data)
    }
    
    func fetchNotRegisteredAuthenticator(callback: @escaping FlutterResult) -> Void {
        guard let profile = ONGUserClient.sharedInstance().authenticatedUserProfile() else {
            callback(SdkError.convertToFlutter(SdkError(customType: .userAuthenticatedProfileIsNull)))
            return
        }
        
        // get not registered authenticators
        let notRegisteredAuthenticators = ONGUserClient.sharedInstance().nonRegisteredAuthenticators(forUser: profile)
        
        // convert list to list of objects with id and name
        let authenticators: [[String: String]] = notRegisteredAuthenticators.compactMap({ ["id" : $0.identifier, "name": $0.name] })
        
        callback(String.stringify(json: authenticators))
    }
}

