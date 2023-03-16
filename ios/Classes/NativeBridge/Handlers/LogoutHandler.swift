import UIKit
import OneginiSDKiOS

protocol LogoutHandlerProtocol: AnyObject {
    func logout(completion: @escaping (Result<Void, FlutterError>) -> Void)
}

class LogoutHandler: LogoutHandlerProtocol {
    func logout(completion: @escaping (Result<Void, FlutterError>) -> Void) {
        let userClient = ONGUserClient.sharedInstance()
        guard userClient.authenticatedUserProfile() != nil else {
            completion(.failure(FlutterError(.noUserProfileIsAuthenticated)))
            return
        }
        userClient.logoutUser { _, error in
            if let error = error {
                let mappedError = ErrorMapper().mapError(error)
                completion(.failure(FlutterError(mappedError)))
            } else {
                completion(.success)
            }
        }
    }
}
