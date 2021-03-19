import Foundation
import OneginiSDKiOS
import OneginiCrypto

typealias FlutterDataCallback = (Any?, SdkError?) -> Void

protocol FetchResourcesHandlerProtocol: AnyObject {
    func authenticateDevice(_ path: String, completion: @escaping (Bool, SdkError?) -> Void)
    func authenticateImplicitly(_ profile: ONGUserProfile, completion: @escaping (Bool, SdkError?) -> Void)
    func resourceRequest(isImplicit: Bool, parameters: [String: Any], completion: @escaping FlutterDataCallback)
    func fetchSimpleResources(_ path: String, parameters: [String: Any?], completion: @escaping FlutterResult)
    func fetchAnonymousResource(_ path: String, parameters: [String: Any?], completion: @escaping FlutterResult)
    func fetchResourceWithImplicitResource(_ path: String, parameters: [String: Any?], completion: @escaping FlutterResult)
}

class ResourcesHandler: FetchResourcesHandlerProtocol {
    func authenticateDevice(_ path: String, completion: @escaping (Bool, SdkError?) -> Void) {
        ONGDeviceClient.sharedInstance().authenticateDevice([path as String]) { success, error in
            if let error = error {
                let mappedError = ErrorMapper().mapError(error)
                completion(success, mappedError)
            } else {
                completion(success, nil)
            }
        }
    }

    func authenticateImplicitly(_ profile: ONGUserProfile, completion: @escaping (Bool, SdkError?) -> Void) {
        if isProfileImplicitlyAuthenticated(profile) {
            completion(true, nil)
        } else {
            authenticateProfileImplicitly(profile) { success, error in
                if success {
                    completion(true, nil)
                } else {
                    if let error = error {
                        completion(false, error)
                    } else {
                        completion(false, SdkError(errorDescription: "Failed to authenticate."))
                    }
                }
            }
        }
    }

    func resourceRequest(isImplicit: Bool, parameters: [String: Any], completion: @escaping FlutterDataCallback) {
        if(isImplicit == true){
            implicitResourcesRequest(parameters, completion)
        } else{
            simpleResourcesRequest(parameters, completion)
        }
    }

    private func isProfileImplicitlyAuthenticated(_ profile: ONGUserProfile) -> Bool {
        let implicitlyAuthenticatedProfile = ONGUserClient.sharedInstance().implicitlyAuthenticatedUserProfile()
        return implicitlyAuthenticatedProfile != nil && implicitlyAuthenticatedProfile == profile
    }

    private func authenticateProfileImplicitly(_ profile: ONGUserProfile, completion: @escaping (Bool, SdkError?) -> Void) {
        ONGUserClient.sharedInstance().implicitlyAuthenticateUser(profile, scopes: nil) { success, error in
            if !success {
                let mappedError = ErrorMapper().mapError(error)
                completion(success, mappedError)
            }
            completion(success, nil)
        }
    }

    private func simpleResourcesRequest(_ parameters: [String: Any], _ completion: @escaping ([String: Any]?, SdkError?) -> Void) {
        let encoding = getEncodingByValue(parameters["encoding"] as! String)

        let request = ONGResourceRequest.init(path: parameters["path"] as! String, method: parameters["method"] as! String, parameters: parameters["parameters"] as? [String : Any], encoding: encoding)

        ONGUserClient.sharedInstance().fetchResource(request) { response, error in
            if let error = error {
                completion(nil, SdkError(errorDescription: error.localizedDescription, code: error.code))
            } else {
                if let data = response?.data {
                    if let responseData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        completion(responseData, nil)
                    } else {
                        completion(nil, SdkError(errorDescription: "Failed to parse data."))
                    }
                } else {
                    completion(nil, SdkError(errorDescription: "Response doesn't contain data."))
                }
            }
        }
    }

    private func implicitResourcesRequest(_ parameters: [String: Any], _ completion: @escaping FlutterDataCallback) {
        let encoding = getEncodingByValue(parameters["encoding"] as! String)

        let implicitRequest = ONGResourceRequest.init(path: parameters["path"] as! String, method: parameters["method"] as! String, parameters: parameters["parameters"] as? [String : Any], encoding: encoding)

        ONGUserClient.sharedInstance().fetchImplicitResource(implicitRequest) { response, error in
            if let error = error {
                completion(nil, SdkError(errorDescription: error.localizedDescription))
            } else {
                if let data = response?.data {
                    if let responseData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        completion(responseData, nil)
                    } else {
                        completion(nil, SdkError(errorDescription: "Failed to parse data"))
                    }
                } else {
                    completion(nil, SdkError(errorDescription: "Response doesn't contain data"))
                }
            }
        }
    }

    private func getEncodingByValue(_ value: String) -> ONGParametersEncoding {
        switch value {
        case "application/json":
            return ONGParametersEncoding.JSON
        case "application/x-www-form-urlencoded":
            return ONGParametersEncoding.formURL
        default:
            return ONGParametersEncoding.JSON
        }
    }
    
    //MARK:- Bridge
    func fetchSimpleResources(_ path: String, parameters: [String: Any?], completion: @escaping FlutterResult) {
        var parameters = [String: Any]()
        parameters["path"] = path
        parameters["encoding"] = "application/x-www-form-urlencoded";
        parameters["method"] = "GET"

        OneginiModuleSwift.sharedInstance.authenticateDeviceForResource(path) { (data) in
            guard let value = data, let _value = value as? Bool, _value else {
                completion(data)
                return
            }

            OneginiModuleSwift.sharedInstance.resourceRequest(false, parameters: parameters) { (_data, error) in
                if let _errorResource = error {
                    completion(_errorResource)
                    return
                } else {
                    if let data = _data, let convertedStringDatat = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted) {
                        let convertedString = String(data: convertedStringDatat, encoding: .utf8)
                        completion(convertedString)
                    } else {
                        completion(data)
                    }
                }
            }
        }
    }
    
    func fetchAnonymousResource(_ path: String, parameters: [String: Any?], completion: @escaping FlutterResult) {
        var parameters = [String: Any]()
        parameters["path"] = path
        parameters["encoding"] = "application/x-www-form-urlencoded";
        parameters["method"] = "GET"

        OneginiModuleSwift.sharedInstance.resourceRequest(false, parameters: parameters) { (_data, error) in
            if let _errorResource = error {
                completion(_errorResource)
                return
            } else {
                if let data = _data, let convertedStringDatat = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted) {
                    let convertedString = String(data: convertedStringDatat, encoding: .utf8)
                    completion(convertedString)
                } else {
                    completion(_data)
                }
            }
        }
    }
    
    func fetchResourceWithImplicitResource(_ path: String, parameters: [String: Any?], completion: @escaping FlutterResult) {
        
        guard let _profile = ONGUserClient.sharedInstance().authenticatedUserProfile() else {
            completion(SdkError.init(customType: .userProfileIsNull))
            return
        }
        
        var parameters = [String: Any]()
        parameters["path"] = path
        parameters["encoding"] = "application/x-www-form-urlencoded";
        parameters["method"] = "GET"
        
        OneginiModuleSwift.sharedInstance.authenticateUserImplicitly(_profile.profileId) { (value, error) in
            if (error == nil) {
                OneginiModuleSwift.sharedInstance.resourceRequest(value, parameters: parameters) { (_data, error) in
                    if let data = _data, let convertedStringDatat = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted) {
                        let convertedString = String(data: convertedStringDatat, encoding: .utf8)
                        completion(convertedString)
                    } else {
                        completion(_data)
                    }
                }
            } else {
                completion(error)
            }
        }
    }
}
