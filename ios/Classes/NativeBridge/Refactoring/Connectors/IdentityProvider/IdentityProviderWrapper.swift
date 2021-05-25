import Foundation
import OneginiSDKiOS
import Flutter

protocol IdentityProviderWrapperProtocol {
    func identityProviders() -> Array<ONGIdentityProvider>
}

class IdentityProviderWrapper: IdentityProviderWrapperProtocol {
    func identityProviders() -> Array<ONGIdentityProvider> {
        let providers = Array(ONGUserClient.sharedInstance().identityProviders())
        return providers
    }
}
