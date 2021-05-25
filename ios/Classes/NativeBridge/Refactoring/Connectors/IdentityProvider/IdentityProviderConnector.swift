import Foundation
import OneginiSDKiOS
import Flutter

protocol IdentityProviderConnectorProtocol {
    func getIdentityProviders(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
}

class IdentityProviderConnector: IdentityProviderConnectorProtocol {
    private(set) var identityProviderWrapper: IdentityProviderWrapperProtocol
    
    init(wrapper: IdentityProviderWrapperProtocol = IdentityProviderWrapper()) {
        self.identityProviderWrapper = wrapper
    }
    
    func getIdentityProviders(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        let list = self.identityProviderWrapper.identityProviders()
        let data = String.stringify(json: list.toDict())
        result(data)
    }
}

extension Array where Element == ONGIdentityProvider {
    func toDict() -> [[String: Any]] {
        let jsonData = self.compactMap { (identityProvider) -> [String: Any]? in
            var data = [String: Any]()
            data[Constants.Parameters.id] = identityProvider.identifier
            data[Constants.Parameters.name] = identityProvider.name
            return data
        }
        
        return jsonData
    }
}
