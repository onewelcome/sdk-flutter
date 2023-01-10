import UIKit
import OneginiSDKiOS
import OneginiCrypto

protocol LogoutHandlerProtocol: AnyObject {
    func logout(completion: @escaping (SdkError?) -> Void)
}

class LogoutHandler: LogoutHandlerProtocol {
    func logout(completion: @escaping ( SdkError?) -> Void) {
        let userClient = ONGUserClient.sharedInstance()
        if userClient.authenticatedUserProfile() != nil {
            userClient.logoutUser { _, error in
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
            completion(SdkError.init(wrapperError: .authenticatedUserProfileIsNull))
        }
    }
}
