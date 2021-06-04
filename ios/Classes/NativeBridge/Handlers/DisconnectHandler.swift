import UIKit
import OneginiSDKiOS
import OneginiCrypto

protocol DisconnectHandlerProtocol: AnyObject {
    func disconnect(userProfileId: String?, completion: @escaping (SdkError?) -> Void)
}

class DisconnectHandler: DisconnectHandlerProtocol {
    func disconnect(userProfileId: String?, completion: @escaping (SdkError?) -> Void){
        let userClient = ONGUserClient.sharedInstance()
        
        var profile: ONGUserProfile?
        if let profileId = userProfileId {
            profile = userClient.userProfiles().first(where: { $0.profileId == profileId })
        } else {
            profile = userClient.authenticatedUserProfile()
        }
        
        if let profile = profile {
            userClient.deregisterUser(profile) { _, error in
                if let error = error {
                    let mappedError = ErrorMapper().mapError(error)
                    completion(mappedError)
                } else {
                    completion(nil)
                }
            }
        }
        else
        {
            completion(SdkError.init(customType: .userAuthenticatedProfileIsNull))
        }
    }
}
