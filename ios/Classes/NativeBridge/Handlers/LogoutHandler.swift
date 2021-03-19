import UIKit
import OneginiSDKiOS
import OneginiCrypto

protocol LogoutHandlerProtocol: AnyObject {
    func logout(completion: @escaping (SdkError?) -> Void)
}

class LogoutHandler: LogoutHandlerProtocol {
    func logout(completion: @escaping ( SdkError?) -> Void) {
        ONGUserClient.sharedInstance().logoutUser { _, error in
            if let error = error {
                let mappedError = ErrorMapper().mapError(error)
                completion(mappedError)
            } else {
                completion(nil)
            }
        }
    }
}
