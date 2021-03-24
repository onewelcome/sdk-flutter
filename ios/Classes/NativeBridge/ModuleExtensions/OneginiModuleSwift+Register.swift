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
        
        var authenticator: ONGAuthenticator? = nil
        let notRegisteredAuthenticators = ONGUserClient.sharedInstance().nonRegisteredAuthenticators(forUser: profile)
        
        // convert list to list of objects with id and name
        for auth in notRegisteredAuthenticators {
            if (auth.identifier == authenticatorId) {
                authenticator = auth
                break
            }
        }
        
        guard (authenticator != nil) else {
            callback(SdkError.convertToFlutter(SdkError(errorDescription: "Couldn't found matching authenticator.")))
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
        
        let jsonData = registeredAuthenticators.compactMap { (registeredAuthenticator) -> [String: Any]? in
            var data = [String: Any]()
            data["id"] = registeredAuthenticator.identifier
            data["name"] = registeredAuthenticator.name
            return data
        }
        
        let data = String.stringify(json: jsonData)
        callback(data)
    }
    
    func fetchNotRegisteredAuthenticator(callback: @escaping FlutterResult) -> Void {
        guard let profile = ONGUserClient.sharedInstance().authenticatedUserProfile() else {
            callback(SdkError.convertToFlutter(SdkError(customType: .userProfileIsNull)))
            return
        }
        
        // get not registered authenticators
        let notRegisteredAuthenticators = ONGUserClient.sharedInstance().nonRegisteredAuthenticators(forUser: profile)
        var authenticators = [[String: String]]()
        
        // convert list to list of objects with id and name
        for auth in notRegisteredAuthenticators {
            authenticators.append(["id" : auth.identifier, "name": auth.name])
        }
        
        // convert data to json
        let encoder = JSONEncoder()
        let jsonData = try! encoder.encode(authenticators)
        let json = String(data: jsonData, encoding: String.Encoding.utf8)
        
        callback(json)
    }
}

