import UIKit
import OneginiSDKiOS
import OneginiCrypto

protocol LogoutInteractorProtocol: AnyObject {
    func logout(completion: @escaping (SdkError?) -> Void)
}

class LogoutInteractor: LogoutInteractorProtocol {
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
