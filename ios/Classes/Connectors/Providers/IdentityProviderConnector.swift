//
//  IdentityProviderConnector.swift
//  onegini
//
//  Created by Patryk Gałach on 22/04/2021.
//

import Foundation
import OneginiSDKiOS

protocol IdentityProviderConnectorProtocol: class {
    func identityProviders(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func getIdentityProviders() -> Array<ONGIdentityProvider>
    func getIdentityProvider(providerId: String?) -> ONGIdentityProvider?
    func setCustomIdentifiers(customIdentifiers: [String])
}

class IdentityProviderConnector: IdentityProviderConnectorProtocol {
    func identityProviders(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        let providers = getIdentityProviders()
        let jsonData: [[String: String]] = providers.compactMap({ ["id" : $0.identifier, "name": $0.name] })
        
        let data = String.stringify(json: jsonData)
        result(data)
    }
    
    func getIdentityProviders() -> Array<ONGIdentityProvider> {
        
        // TODO: implement wrapper
        let identityProviders = Array(ONGUserClient.sharedInstance().identityProviders())
        return identityProviders
    }
    
    func getIdentityProvider(providerId: String?) -> ONGIdentityProvider? {
        let identityProviders = getIdentityProviders()
        var identityProvider = identityProviders.first(where: { $0.identifier == providerId})
        if let _providerId = providerId, identityProvider == nil {
            identityProvider = ONGIdentityProvider()
            identityProvider?.name = _providerId
            identityProvider?.identifier = _providerId
        }
        
        return identityProvider
    }
    
    func setCustomIdentifiers(customIdentifiers: [String]) {
        
        // TODO: implement
    }
}
