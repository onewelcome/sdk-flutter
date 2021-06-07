import UIKit
import OneginiSDKiOS
import OneginiCrypto

protocol DisconnectHandlerProtocol: AnyObject {
    func disconnect(userProfileId: String?, completion: @escaping (SdkError?) -> Void)
}

class DisconnectHandler: DisconnectHandlerProtocol {
    func disconnect(userProfileId: String?, completion: @escaping (SdkError?) -> Void){
        let userClient = ONGUserClient.sharedInstance()
        
        guard let profileId = userProfileId,
              let profile = userClient.userProfiles().first(where: { $0.profileId == profileId })
        else {
            completion(SdkError.init(customType: .userAuthenticatedProfileIsNull))
            return
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
