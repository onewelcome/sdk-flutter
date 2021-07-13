import Flutter
import Foundation
import OneginiSDKiOS

protocol IdentityProviderConnectorProtocol {
    func getIdentityProviders(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
}

class IdentityProviderConnector: IdentityProviderConnectorProtocol {
    private(set) var identityProviderWrapper: IdentityProviderWrapperProtocol

    init(wrapper: IdentityProviderWrapperProtocol = IdentityProviderWrapper()) {
        identityProviderWrapper = wrapper
    }

    func getIdentityProviders(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        Logger.log("getIdentityProviders", sender: self)
        let list = identityProviderWrapper.identityProviders()
        let data = String.stringify(json: list.toDict())
        result(data)
    }
}

extension Array where Element == ONGIdentityProvider {
    func toDict() -> [[String: Any]] {
        let jsonData = compactMap { (identityProvider) -> [String: Any]? in
            var data = [String: Any]()
            data[Constants.Parameters.id] = identityProvider.identifier
            data[Constants.Parameters.name] = identityProvider.name
            return data
        }

        return jsonData
    }
}
