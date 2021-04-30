//
//  IdentityProviderConnector.swift
//  onegini
//
//  Created by Patryk Gałach on 22/04/2021.
//

import Foundation
import OneginiSDKiOS

protocol IdentityProviderConnectorProtocol: class {
    func getIdentityProviders(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func getIdentityProviders() -> Array<ONGIdentityProvider>
    func getIdentityProviderWith(providerId: String?) -> ONGIdentityProvider?
}

class IdentityProviderConnector: IdentityProviderConnectorProtocol {
    var wrapper: IdentityProviderWrapperProtocol
    
    init(identityProviderWrapper: IdentityProviderWrapperProtocol) {
        self.wrapper = identityProviderWrapper
    }
    
    func getIdentityProviders(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        let providers = getIdentityProviders()
        let jsonData: [[String: String]] = providers.compactMap({ ["id" : $0.identifier, "name": $0.name] })
        
        let data = String.stringify(json: jsonData)
        result(data)
    }
    
    func getIdentityProviders() -> Array<ONGIdentityProvider> {
        return self.wrapper.getIdentityProviders()
    }
    
    func getIdentityProviderWith(providerId: String?) -> ONGIdentityProvider? {
        let identityProviders = getIdentityProviders()
        var identityProvider = identityProviders.first(where: { $0.identifier == providerId})
        if let _providerId = providerId, identityProvider == nil {
            identityProvider = ONGIdentityProvider()
            identityProvider?.name = _providerId
            identityProvider?.identifier = _providerId
        }
        
        return identityProvider
    }
}

protocol IdentityProviderWrapperProtocol: class {
    func getIdentityProviders() -> Array<ONGIdentityProvider>
}

class IdentityProviderWrapper: IdentityProviderWrapperProtocol {
    func getIdentityProviders() -> Array<ONGIdentityProvider> {
        let identityProviders = Array(ONGUserClient.sharedInstance().identityProviders())
        return identityProviders
    }
}
