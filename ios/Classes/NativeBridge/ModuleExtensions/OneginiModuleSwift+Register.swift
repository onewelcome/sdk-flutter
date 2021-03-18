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
    
    func registerFingerprintAuthenticator(callback: @escaping FlutterResult) -> Void {
        guard let profile = ONGUserClient.sharedInstance().authenticatedUserProfile() else {
            callback(SdkError.convertToFlutter(SdkError(customType: .userProfileIsNull)))
            return
        }
        
        let notRegisteredAuthenticators = ONGUserClient.sharedInstance().nonRegisteredAuthenticators(forUser: profile)
        
        if notRegisteredAuthenticators.count == 0 {
            callback(SdkError.convertToFlutter(SdkError(customType: .notRegisteredAuthenticatorsIsNull)))
        }
        
        let isAuthenticatorRegistered = bridgeConnector.toAuthenticatorsHandler.isAuthenticatorRegistered(ONGAuthenticatorType.biometric, profile)
        
        guard !isAuthenticatorRegistered else {
            callback(SdkError.convertToFlutter(SdkError(customType: .fingerprintAuthenticatorIsNull)))
            return
        }

        bridgeConnector.toAuthenticatorsHandler.registerAuthenticator(profile, ONGAuthenticatorType.biometric) {
            (_ , error) -> Void in

            if let _error = error {
                callback(SdkError.convertToFlutter(_error))
            } else {
                callback(true)
            }
        }
    }
    
    func fetchNotRegisteredAuthenticator(callback: @escaping FlutterResult) -> Void {
        guard let profile = ONGUserClient.sharedInstance().authenticatedUserProfile() else {
            callback(SdkError.convertToFlutter(SdkError(customType: .userProfileIsNull)))
            return
        }
        
        let notRegisteredAuthenticators = ONGUserClient.sharedInstance().nonRegisteredAuthenticators(forUser: profile)
        
        if notRegisteredAuthenticators.count == 0 {
            callback(false)
        }
        
        let result = notRegisteredAuthenticators.filter({ !$0.isRegistered && $0.type == .biometric }).count == 0 ? false : true
        
        callback(result)
    }
}

