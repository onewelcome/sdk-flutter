import UIKit
import OneginiSDKiOS
import OneginiCrypto

protocol FetchImplicitDataInteractorProtocol: AnyObject {
    func fetchImplicitResources(profile: ONGUserProfile, completion: @escaping FlutterDataCallback)
}

class FetchImplicitDataInteractor: FetchImplicitDataInteractorProtocol {
    var callback: FlutterDataCallback?

    func fetchImplicitResources(profile: ONGUserProfile, completion: @escaping FlutterDataCallback) {
        self.callback = completion
        
        if isProfileImplicitlyAuthenticated(profile) {
            implicitResourcesRequest { [weak self] userIdDecorated, error in
                guard let weakSelf = self else { return }
                if let userIdDecorated = userIdDecorated {
                    weakSelf.callback?(userIdDecorated, nil)
                } else if let error = error {
                    weakSelf.callback?(nil, error)
                }
            }
        } else {
            authenticateUserImplicitly(profile) { [weak self] success, error in
                guard let weakSelf = self else { return }
                if success {
                    weakSelf.implicitResourcesRequest { userIdDecorated, error in
                        if let userIdDecorated = userIdDecorated {
                            weakSelf.callback?(userIdDecorated, nil)
                        } else if let error = error {
                            weakSelf.callback?(nil, error)
                        }
                    }
                } else {
                    if let error = error {
                        weakSelf.callback?(nil, error)
                    }
                }
            }
        }
    }

    fileprivate func isProfileImplicitlyAuthenticated(_ profile: ONGUserProfile) -> Bool {
        let implicitlyAuthenticatedProfile = ONGUserClient.sharedInstance().implicitlyAuthenticatedUserProfile()
        return implicitlyAuthenticatedProfile != nil && implicitlyAuthenticatedProfile == profile
    }

    fileprivate func authenticateUserImplicitly(_ profile: ONGUserProfile, completion: @escaping (Bool, SdkError?) -> Void) {
        ONGUserClient.sharedInstance().implicitlyAuthenticateUser(profile, scopes: nil) { success, error in
            if !success {
                let mappedError = ErrorMapper().mapError(error)
                completion(success, mappedError)
            }
            completion(success, nil)
        }
    }

    fileprivate func implicitResourcesRequest(completion: @escaping (String?, SdkError?) -> Void) {
        let implicitRequest = ONGResourceRequest(path: "user-id-decorated", method: "GET")
        ONGUserClient.sharedInstance().fetchImplicitResource(implicitRequest) { response, error in
            if let error = error {
                let mappedError = ErrorMapper().mapError(error)
                completion(nil, mappedError)
            } else {
                if let data = response?.data, let responseData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String],
                        let userIdDecorated = responseData["decorated_user_id"] {
                    completion(userIdDecorated, nil)
                }
            }
        }
    }
}
