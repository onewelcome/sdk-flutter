import UIKit
import OneginiSDKiOS
import OneginiCrypto

protocol DeregisterUserHandlerProtocol: AnyObject {
    func deregister(_ profileId: String, completion: @escaping (SdkError?) -> Void)
}

class DeregisterUserHandler: DeregisterUserHandlerProtocol {
    func deregister(_ profileId: String, completion: @escaping (SdkError?) -> Void) {
        guard let profile = ONGUserClient.sharedInstance().userProfiles().first(where: { $0.profileId == profileId }) else {
            return completion(SdkError(.userProfileDoesNotExist))
        }
        
        userClient.deregisterUser(profile) { _, error in
            if let error = error {
                let mappedError = ErrorMapper().mapError(error)
                completion(mappedError)
            } else {
                completion(nil)
            }
        }
    }
}
