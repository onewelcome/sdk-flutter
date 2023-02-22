import Foundation
import OneginiSDKiOS
import OneginiCrypto
import Flutter

extension OneginiModuleSwift {

    func deregisterUser(profileId: String, callback: @escaping FlutterResult) {
        bridgeConnector.toDeregisterUserHandler.deregister(profileId: profileId) { (error) in
            error != nil ? callback(SdkError.convertToFlutter(error)) : callback(true)
        }
    }

    func registerUser(_ identityProviderId: String? = nil, scopes: [String]? = nil, callback: @escaping FlutterResult) -> Void {

        bridgeConnector.toRegistrationConnector.registrationHandler.signUp(identityProviderId, scopes: scopes) { (_, userProfile, userInfo, error) -> Void in

            if let _userProfile = userProfile {
                var result = Dictionary<String, Any?>()
                result["userProfile"] = ["profileId": _userProfile.profileId]
                
                if let userInfo = userInfo {
                    result["customInfo"] = ["status": userInfo.status, "data": userInfo.data]
                }

                callback(String.stringify(json: result))
            } else {
                callback(SdkError.convertToFlutter(error))
            }
        }
    }
    
    func handleRegisteredProcessUrl(_ url: String, webSignInType: WebSignInType) -> Void {
        bridgeConnector.toRegistrationConnector.registrationHandler.processRedirectURL(url: url, webSignInType: webSignInType)
    }
    
    public func handleDeepLinkCallbackUrl(_ url: URL) -> Bool {
        guard let schemeLibrary = URL.init(string: ONGClient.sharedInstance().configModel.redirectURL)?.scheme else {
            generateEventError(value: "RedirectURL's scheme of configModel is empty: \(String(describing: ONGClient.sharedInstance().configModel.redirectURL))")
            return false
        }
        
        guard let scheme = url.scheme,
              scheme.compare(schemeLibrary, options: .caseInsensitive) == .orderedSame else {
            let value = ["url_scheme": url.scheme, "library_scheme": schemeLibrary, "url": url.absoluteString]
            generateEventError(value: value)
            return false
        }
        
        bridgeConnector.toRegistrationConnector.registrationHandler.handleRedirectURL(url: url)
        return true
    }
    
    private func generateEventError(value: Any?) {
        var errorParameters = [String: Any]()
        errorParameters["eventName"] = "eventError"
        errorParameters["eventValue"] = value
        
        let data = String.stringify(json: errorParameters)
        OneginiModuleSwift.sharedInstance.sendBridgeEvent(eventName: OneginiBridgeEvents.pinNotification, data: data)
    }
    
    func submitCustomRegistrationSuccess(_ data: String) {
        bridgeConnector.toRegistrationConnector.registrationHandler.submitCustomRegistrationSuccess(data)
    }
    
    func submitCustomRegistrationError(_ error: String) {
        bridgeConnector.toRegistrationConnector.registrationHandler.cancelCustomRegistration(error)
    }
    
    public func cancelBrowserRegistration() -> Void {
        bridgeConnector.toRegistrationConnector.registrationHandler.cancelBrowserRegistration()
    }
    
    func registerAuthenticator(_ authenticatorId: String, callback: @escaping FlutterResult) {
        guard let profile = ONGUserClient.sharedInstance().authenticatedUserProfile() else {
            return callback(SdkError.convertToFlutter(SdkError(.noUserProfileIsAuthenticated)))
        }

        let notRegisteredAuthenticators = ONGUserClient.sharedInstance().nonRegisteredAuthenticators(forUser: profile)

        guard let authenticator = notRegisteredAuthenticators.first(where: { $0.identifier == authenticatorId }) else {
            callback(SdkError.convertToFlutter(SdkError(.authenticatorNotFound)))
            return
        }

        bridgeConnector.toAuthenticatorsHandler.registerAuthenticator(profile, authenticator) {
            (_ , error) -> Void in

            if let _error = error {
                callback(SdkError.convertToFlutter(_error))
            } else {
                callback(nil)
            }
        }
    }
    
    func getRegisteredAuthenticators(_ profileId: String, callback: @escaping FlutterResult) {
        guard let profile = ONGUserClient.sharedInstance().userProfiles().first(where: { $0.profileId == profileId }) else {
            callback(SdkError.convertToFlutter(SdkError(.userProfileDoesNotExist)))
            return
        }

        let registeredAuthenticators = ONGUserClient.sharedInstance().registeredAuthenticators(forUser: profile)

        let authenticators: [[String: String]] = registeredAuthenticators.compactMap({ ["id" : $0.identifier, "name": $0.name] })

        let data = String.stringify(json: authenticators)
        callback(data)
    }
    
    func getNotRegisteredAuthenticators(_ profileId: String, callback: @escaping FlutterResult) -> Void {
        guard let profile = ONGUserClient.sharedInstance().userProfiles().first(where: { $0.profileId == profileId }) else {
            callback(SdkError.convertToFlutter(SdkError(.userProfileDoesNotExist)))
            return
        }

        // get not registered authenticators
        let notRegisteredAuthenticators = ONGUserClient.sharedInstance().nonRegisteredAuthenticators(forUser: profile)

        // convert list to list of objects with id and name
        let authenticators: [[String: String]] = notRegisteredAuthenticators.compactMap({ ["id" : $0.identifier, "name": $0.name] })

        callback(String.stringify(json: authenticators))
    }
    
    func getAllAuthenticators(_ profileId: String, callback: @escaping FlutterResult) -> Void {
        guard let profile = ONGUserClient.sharedInstance().userProfiles().first(where: { $0.profileId == profileId }) else {
            callback(SdkError.convertToFlutter(SdkError(.userProfileDoesNotExist)))
            return
        }

        // get all authenticators
        let allAuthenticators = ONGUserClient.sharedInstance().allAuthenticators(forUser: profile)

        // convert list to list of objects with id and name
        let authenticators: [[String: String]] = allAuthenticators.compactMap({ ["id" : $0.identifier, "name": $0.name] })

        callback(String.stringify(json: authenticators))
    }
}

