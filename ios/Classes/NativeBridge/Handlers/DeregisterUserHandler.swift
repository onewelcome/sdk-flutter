import UIKit
import OneginiSDKiOS
import OneginiCrypto

protocol DeregisterUserHandlerProtocol: AnyObject {
    func deregister(profileId: String, completion: @escaping (SdkError?) -> Void)
}

class DeregisterUserHandler: DeregisterUserHandlerProtocol {
    func deregister(profileId: String, completion: @escaping (SdkError?) -> Void) {
        guard let profile = ONGUserClient.sharedInstance().userProfiles().first(where: { $0.profileId == profileId }) else {
            completion(SdkError(.userProfileDoesNotExist))
            return
        }
        
        ONGUserClient.sharedInstance().deregisterUser(profile) { _, error in
            if let error = error {
                let mappedError = ErrorMapper().mapError(error)
                completion(mappedError)
            } else {
                completion(nil)
            }
        }
    }
}
