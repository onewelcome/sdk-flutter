import Flutter
import Foundation
import OneginiSDKiOS

protocol IdentityProviderWrapperProtocol {
    func identityProviders() -> Array<ONGIdentityProvider>
}

class IdentityProviderWrapper: IdentityProviderWrapperProtocol {
    func identityProviders() -> Array<ONGIdentityProvider> {
        let providers = Array(ONGUserClient.sharedInstance().identityProviders())
        return providers
    }
}
