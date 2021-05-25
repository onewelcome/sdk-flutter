import Foundation
import OneginiSDKiOS

protocol AuthenticatorWrapperProtocol {
    func authenticatedUserProfile() -> ONGUserProfile?
    func allAuthenticators(for userProfile: ONGUserProfile) -> Array<ONGAuthenticator>
    func registeredAuthenticators(for userProfile: ONGUserProfile) -> Array<ONGAuthenticator>
    func nonRegisteredAuthenticators(for userProfile: ONGUserProfile) -> Array<ONGAuthenticator>
    func setPreffered(authenticator: ONGAuthenticator)
}

class AuthenticatorWrapper: AuthenticatorWrapperProtocol {
    func authenticatedUserProfile() -> ONGUserProfile? {
        return ONGUserClient.sharedInstance().authenticatedUserProfile()
    }
    
    func allAuthenticators(for userProfile: ONGUserProfile) -> Array<ONGAuthenticator> {
        return Array(ONGUserClient.sharedInstance().allAuthenticators(forUser: userProfile))
    }
    
    func registeredAuthenticators(for userProfile: ONGUserProfile) -> Array<ONGAuthenticator> {
        return Array(ONGUserClient.sharedInstance().registeredAuthenticators(forUser: userProfile))
    }
    
    func nonRegisteredAuthenticators(for userProfile: ONGUserProfile) -> Array<ONGAuthenticator> {
        return Array(ONGUserClient.sharedInstance().nonRegisteredAuthenticators(forUser: userProfile))
    }
    
    func setPreffered(authenticator: ONGAuthenticator) {
        ONGUserClient.sharedInstance().preferredAuthenticator = authenticator
    }
}

