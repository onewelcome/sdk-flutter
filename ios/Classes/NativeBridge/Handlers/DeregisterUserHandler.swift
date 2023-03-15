import UIKit
import OneginiSDKiOS

protocol DeregisterUserHandlerProtocol: AnyObject {
    func deregister(profileId: String, completion: @escaping (Result<Void, FlutterError>) -> Void)
}

class DeregisterUserHandler: DeregisterUserHandlerProtocol {
    func deregister(profileId: String, completion: @escaping (Result<Void, FlutterError>) -> Void) {
        guard let profile = ONGUserClient.sharedInstance().userProfiles().first(where: { $0.profileId == profileId }) else {
            completion(.failure(FlutterError(.userProfileDoesNotExist)))
            return
        }
        
        ONGUserClient.sharedInstance().deregisterUser(profile) { _, error in
            if let error = error {
                let mappedError = ErrorMapper().mapError(error)
                completion(.failure(FlutterError(mappedError)))
            } else {
                completion(.success(()))
            }
        }
    }
}
