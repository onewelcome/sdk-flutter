import Foundation
import OneginiSDKiOS
import Flutter

protocol AuthenticatorConnectorProtocol {
    func getAllAuthenticators(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    func getRegisteredAuthenticators(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    func getNonRegisteredAuthenticators(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
}

class AuthenticatorConnector: AuthenticatorConnectorProtocol {
    private(set) var authenticatorWrapper: AuthenticatorWrapperProtocol
    
    init(wrapper: AuthenticatorWrapperProtocol = AuthenticatorWrapper()) {
        self.authenticatorWrapper = wrapper
    }
    
    func getAllAuthenticators(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard let profile = ONGUserClient.sharedInstance().authenticatedUserProfile() else {
            result(FlutterError.from(customType: .noUserAuthenticated))
            return
        }
        
        let authenticators = self.authenticatorWrapper.allAuthenticators(for: profile)
        let data = String.stringify(json: authenticators.toDict())
        
        result(data)
    }
    
    func getRegisteredAuthenticators(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard let profile = ONGUserClient.sharedInstance().authenticatedUserProfile() else {
            result(FlutterError.from(customType: .noUserAuthenticated))
            return
        }
        
        let authenticators = self.authenticatorWrapper.registeredAuthenticators(for: profile)
        let data = String.stringify(json: authenticators.toDict())
        
        result(data)
    }
    
    func getNonRegisteredAuthenticators(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard let profile = ONGUserClient.sharedInstance().authenticatedUserProfile() else {
            result(FlutterError.from(customType: .noUserAuthenticated))
            return
        }
        
        let authenticators = self.authenticatorWrapper.nonRegisteredAuthenticators(for: profile)
        let data = String.stringify(json: authenticators.toDict())
        
        result(data)
    }
}

extension Array where Element == ONGAuthenticator {
    func toDict() -> [[String: Any]] {
        let jsonData = self.compactMap { (identityProvider) -> [String: Any]? in
            return [Constants.Parameters.id: identityProvider.identifier,
                    Constants.Parameters.name: identityProvider.name]
        }
        
        return jsonData
    }
}
