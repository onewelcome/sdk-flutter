import Foundation
import OneginiSDKiOS

protocol AuthenticatorWrapperProtocol {
    func authenticatedUserProfile() -> ONGUserProfile?
    func allAuthenticators(for userProfile: ONGUserProfile) -> Array<ONGAuthenticator>
}

class AuthenticatorWrapper: AuthenticatorWrapperProtocol {
    func authenticatedUserProfile() -> ONGUserProfile? {
        return ONGUserClient.sharedInstance().authenticatedUserProfile()
    }
    
    func allAuthenticators(for userProfile: ONGUserProfile) -> Array<ONGAuthenticator> {
        return Array(ONGUserClient.sharedInstance().allAuthenticators(forUser: userProfile))
    }
}

