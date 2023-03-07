import Foundation
import OneginiSDKiOS
import Flutter



extension OneginiModuleSwift {

    func deregisterUser(profileId: String, completion: @escaping (Result<Void, FlutterError>) -> Void) {
        bridgeConnector.toDeregisterUserHandler.deregister(profileId: profileId, completion: completion)
    }

    func registerUser(_ identityProviderId: String? = nil, scopes: [String]? = nil, completion: @escaping (Result<OWRegistrationResponse, FlutterError>) -> Void) {
        bridgeConnector.toRegistrationConnector.registrationHandler.registerUser(identityProviderId, scopes: scopes, completion: completion)
    }
    
    func handleRegisteredProcessUrl(_ url: String, webSignInType: Int) -> Result<Void, FlutterError> {
        return bridgeConnector.toRegistrationConnector.registrationHandler.processRedirectURL(url: url, webSignInType: webSignInType)
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
    
    func submitCustomRegistrationSuccess(_ data: String?) {
        bridgeConnector.toRegistrationConnector.registrationHandler.submitCustomRegistrationSuccess(data)
    }
    
    func submitCustomRegistrationError(_ error: String) {
        bridgeConnector.toRegistrationConnector.registrationHandler.cancelCustomRegistration(error)
    }
    
    public func cancelBrowserRegistration() -> Void {
        bridgeConnector.toRegistrationConnector.registrationHandler.cancelBrowserRegistration()
    }
    
    func registerAuthenticator(_ authenticatorId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        bridgeConnector.toAuthenticatorsHandler.registerAuthenticator(authenticatorId, completion)
    }
    
    func getRegisteredAuthenticators(_ profileId: String) -> Result<[OWAuthenticator], FlutterError> {
        guard let profile = ONGUserClient.sharedInstance().userProfiles().first(where: { $0.profileId == profileId }) else {
            return .failure(FlutterError(.userProfileDoesNotExist))
        }
        let registeredAuthenticators = ONGUserClient.sharedInstance().registeredAuthenticators(forUser: profile)
        return .success(registeredAuthenticators.compactMap({OWAuthenticator($0)}))
    }
    
    func getNotRegisteredAuthenticators(_ profileId: String) -> Result<[OWAuthenticator], FlutterError> {
        guard let profile = ONGUserClient.sharedInstance().userProfiles().first(where: { $0.profileId == profileId }) else {
            return .failure(FlutterError(.userProfileDoesNotExist))
        }
        let notRegisteredAuthenticators = ONGUserClient.sharedInstance().nonRegisteredAuthenticators(forUser: profile)
        return .success(notRegisteredAuthenticators.compactMap({OWAuthenticator($0)}))
    }
    
    func getAllAuthenticators(_ profileId: String) -> Result<[OWAuthenticator], FlutterError> {
        guard let profile = ONGUserClient.sharedInstance().userProfiles().first(where: { $0.profileId == profileId }) else {
            return .failure(FlutterError(.userProfileDoesNotExist))
        }
        let allAuthenticators = ONGUserClient.sharedInstance().allAuthenticators(forUser: profile)
        return .success(allAuthenticators.compactMap({OWAuthenticator($0)}))
    }
    
    func getRedirectUrl() -> Result<String, FlutterError> {
        return .success(ONGClient.sharedInstance().configModel.redirectURL)
    }
}

