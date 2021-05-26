import Foundation
import OneginiSDKiOS
import Flutter

protocol AuthenticatorConnectorProtocol {
    func getAllAuthenticators(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    func getRegisteredAuthenticators(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    func getNonRegisteredAuthenticators(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    func setPreferredAuthenticator(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    func registerAuthenticator(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    func deregisterAuthenticator(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    func isAuthenticatorRegistered(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
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
    
    func setPreferredAuthenticator(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any],
              let authenticatorId = arguments[Constants.Parameters.authenticatorId] as? String else
        {
            result(FlutterError.from(customType: .invalidArguments))
            return
        }
        
        guard let profile = self.authenticatorWrapper.authenticatedUserProfile() else
        {
            result(FlutterError.from(customType: .noUserAuthenticated))
            return
        }
        
        guard let authenticator = self.authenticatorWrapper.registeredAuthenticators(for: profile).first(where: {$0.identifier == authenticatorId }) else
        {
            result(FlutterError.from(customType: .noSuchAuthenticator))
            return
        }
        
        self.authenticatorWrapper.setPreffered(authenticator: authenticator)
        
        result(true)
    }
    
    func registerAuthenticator(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any],
              let authenticatorId = arguments[Constants.Parameters.authenticatorId] as? String else
        {
            result(FlutterError.from(customType: .invalidArguments))
            return
        }
        
        guard let profile = self.authenticatorWrapper.authenticatedUserProfile() else
        {
            result(FlutterError.from(customType: .noUserAuthenticated))
            return
        }
        
        guard let authenticator = self.authenticatorWrapper.nonRegisteredAuthenticators(for: profile).first(where: {$0.identifier == authenticatorId }) else
        {
            result(FlutterError.from(customType: .noSuchAuthenticator))
            return
        }
        
        self.authenticatorWrapper.register(authenticator: authenticator) { (value, error) in
            guard let error = error else {
                result(value)
                return
            }
            
            result(FlutterError.from(error: error))
        }
    }
    
    func deregisterAuthenticator(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any],
              let authenticatorId = arguments[Constants.Parameters.authenticatorId] as? String else
        {
            result(FlutterError.from(customType: .invalidArguments))
            return
        }
        
        guard let profile = self.authenticatorWrapper.authenticatedUserProfile() else
        {
            result(FlutterError.from(customType: .noUserAuthenticated))
            return
        }
        
        guard let authenticator = self.authenticatorWrapper.nonRegisteredAuthenticators(for: profile).first(where: {$0.identifier == authenticatorId }) else
        {
            result(FlutterError.from(customType: .noSuchAuthenticator))
            return
        }
        
        self.authenticatorWrapper.deregister(authenticator: authenticator) { (value, error) in
            guard let error = error else {
                result(value)
                return
            }
            
            result(FlutterError.from(error: error))
        }
    }
    
    func isAuthenticatorRegistered(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any],
              let authenticatorId = arguments[Constants.Parameters.authenticatorId] as? String else
        {
            result(FlutterError.from(customType: .invalidArguments))
            return
        }
        
        guard let profile = self.authenticatorWrapper.authenticatedUserProfile() else
        {
            result(FlutterError.from(customType: .noUserAuthenticated))
            return
        }
        
        let authenticator = self.authenticatorWrapper.registeredAuthenticators(for: profile).first(where: {$0.identifier == authenticatorId })
        let isRegistered = authenticator != nil ? true : false
        
        result(isRegistered)
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
