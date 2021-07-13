import Flutter
import Foundation
import OneginiSDKiOS

typealias DisconnectCallbackResult = (Any?, Error?) -> Void

// MARK: DisconnectWrapperrProtocol

protocol DisconnectWrapperrProtocol {
    func authenticatedUserProfile() -> ONGUserProfile?
    func userProfile(by profileId: String) -> ONGUserProfile?
    func deregisterUser(_ userProfile: ONGUserProfile, completion: @escaping DisconnectCallbackResult)
    func logoutUser(completion: @escaping DisconnectCallbackResult)
}

// MARK: DisconnectWrapper

class DisconnectWrapper: DisconnectWrapperrProtocol {
    func authenticatedUserProfile() -> ONGUserProfile? {
        return ONGUserClient.sharedInstance().authenticatedUserProfile()
    }

    func userProfile(by profileId: String) -> ONGUserProfile? {
        return ONGUserClient.sharedInstance().userProfiles().first(where: { $0.profileId == profileId })
    }

    func deregisterUser(_ userProfile: ONGUserProfile, completion: @escaping DisconnectCallbackResult) {
        ONGUserClient.sharedInstance().deregisterUser(userProfile, completion: completion)
    }

    func logoutUser(completion: @escaping DisconnectCallbackResult) {
        ONGUserClient.sharedInstance().logoutUser(completion)
    }
}
