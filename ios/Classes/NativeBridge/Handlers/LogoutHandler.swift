import UIKit
import OneginiSDKiOS

protocol LogoutHandlerProtocol: AnyObject {
    func logout(completion: @escaping (Result<Void, FlutterError>) -> Void)
}

class LogoutHandler: LogoutHandlerProtocol {
    func logout(completion: @escaping (Result<Void, FlutterError>) -> Void) {
        let userClient = ONGUserClient.sharedInstance()
        if userClient.authenticatedUserProfile() != nil {
            userClient.logoutUser { _, error in
                if let error = error {
                    let mappedError = ErrorMapper().mapError(error)
                    completion(.failure(FlutterError(mappedError)))
                } else {
                    completion(.success)
                }
            }
        }
        else
        {
            completion(.failure(FlutterError(.noUserProfileIsAuthenticated)))
        }
    }
}
