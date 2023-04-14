import Foundation
import OneginiSDKiOS
import Flutter

extension OneginiModuleSwift {

    func deregisterUser(profileId: String, completion: @escaping (Result<Void, FlutterError>) -> Void) {
        bridgeConnector.toDeregisterUserHandler.deregister(profileId: profileId, completion: completion)
    }

    func registerUser(_ identityProviderId: String? = nil, scopes: [String]? = nil, completion: @escaping (Result<OWRegistrationResponse, FlutterError>) -> Void) {
        bridgeConnector.toRegistrationHandler.registerUser(identityProviderId, scopes: scopes, completion: completion)
    }

    func handleRegisteredProcessUrl(_ url: String, webSignInType: Int) -> Result<Void, FlutterError> {
        return bridgeConnector.toRegistrationHandler.processRedirectURL(url: url, webSignInType: webSignInType)
    }

    public func handleDeepLinkCallbackUrl(_ url: URL) -> Bool {
        guard let schemeLibrary = URL.init(string: ONGClient.sharedInstance().configModel.redirectURL)?.scheme else {
            // FIXME: We should propagate an error here to the caller, not through events.
            return false
        }

        guard let scheme = url.scheme,
              scheme.compare(schemeLibrary, options: .caseInsensitive) == .orderedSame else {
            let value = ["url_scheme": url.scheme, "library_scheme": schemeLibrary, "url": url.absoluteString]
            // FIXME: We should propagate an error here to the caller, not through events.
            return false
        }

        bridgeConnector.toRegistrationHandler.handleRedirectURL(url: url)
        return true
    }

    func submitCustomRegistrationSuccess(_ data: String?, completion: @escaping (Result<Void, FlutterError>) -> Void) {
        bridgeConnector.toRegistrationHandler.submitCustomRegistrationSuccess(data, completion)
    }

    func submitCustomRegistrationError(_ error: String, _ completion: @escaping (Result<Void, FlutterError>) -> Void) {
        bridgeConnector.toRegistrationHandler.cancelCustomRegistration(error, completion)
    }

    public func cancelBrowserRegistration(_ completion: @escaping (Result<Void, FlutterError>) -> Void) {
        bridgeConnector.toRegistrationHandler.cancelBrowserRegistration(completion)
    }  

    func getRedirectUrl() -> Result<String, FlutterError> {
        return .success(ONGClient.sharedInstance().configModel.redirectURL)
    }
}
