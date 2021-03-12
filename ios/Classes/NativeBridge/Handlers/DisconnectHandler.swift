import UIKit
import OneginiSDKiOS
import OneginiCrypto

protocol DisconnectHandlerProtocol: AnyObject {
    func disconnect(completion: @escaping (SdkError?) -> Void)
}

class DisconnectHandler: DisconnectHandlerProtocol {
    func disconnect(completion: @escaping (SdkError?) -> Void){
        let userClient = ONGUserClient.sharedInstance()
        if let profile = userClient.authenticatedUserProfile() {
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
}
