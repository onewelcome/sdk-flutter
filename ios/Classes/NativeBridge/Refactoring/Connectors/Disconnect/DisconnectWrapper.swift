import Foundation
import OneginiSDKiOS
import Flutter

typealias DisconnectCallbackResult = (Any?, Error?) -> Void

//MARK: DisconnectWrapperrProtocol
protocol DisconnectWrapperrProtocol {
    func authenticatedUserProfile() -> ONGUserProfile?
    func deregisterUser(_ userProfile: ONGUserProfile, completion: @escaping DisconnectCallbackResult)
    func logoutUser(completion: @escaping DisconnectCallbackResult)
}

//MARK: DisconnectWrapper
class DisconnectWrapper: DisconnectWrapperrProtocol {
    func authenticatedUserProfile() -> ONGUserProfile? {
        return ONGUserClient.sharedInstance().authenticatedUserProfile()
    }
    
    func deregisterUser(_ userProfile: ONGUserProfile, completion: @escaping DisconnectCallbackResult) {
        Logger.log("DeregisterUser", sender: self)
        ONGUserClient.sharedInstance().deregisterUser(userProfile, completion: completion)
    }
    
    func logoutUser(completion: @escaping DisconnectCallbackResult) {
        Logger.log("LogoutUser", sender: self)
        ONGUserClient.sharedInstance().logoutUser(completion)
    }
}
