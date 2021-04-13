import Foundation
import OneginiSDKiOS
import OneginiCrypto

typealias FlutterDataCallback = (Any?, SdkError?) -> Void

protocol FetchResourcesHandlerProtocol: AnyObject {
    func authenticateDevice(_ path: String, completion: @escaping (Bool, SdkError?) -> Void)
    func authenticateImplicitly(_ profile: ONGUserProfile, completion: @escaping (Bool, SdkError?) -> Void)
    func resourceRequest(isImplicit: Bool, isAnonymousCall: Bool, parameters: [String: Any], completion: @escaping FlutterDataCallback)
    func fetchSimpleResources(_ path: String, parameters: [String: Any?], completion: @escaping FlutterResult)
    func fetchAnonymousResource(_ path: String, parameters: [String: Any?], completion: @escaping FlutterResult)
    func fetchResourceWithImplicitResource(_ path: String, parameters: [String: Any?], completion: @escaping FlutterResult)
    func unauthenticatedRequest(_ path: String, parameters: [String: Any?], callback: @escaping FlutterResult)
}

//MARK: -
class ResourcesHandler: FetchResourcesHandlerProtocol {
    
    func authenticateDevice(_ path: String, completion: @escaping (Bool, SdkError?) -> Void) {
        print("[\(type(of: self))] authenticateDevice")
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
        print("[\(type(of: self))] authenticateImplicitly")
        if isProfileImplicitlyAuthenticated(profile) {
            print("[\(type(of: self))] authenticateImplicitly - isProfileImplicitlyAuthenticated")
            completion(true, nil)
        } else {
            print("[\(type(of: self))] authenticateImplicitly - isProfileImplicitlyAuthenticated else")
            authenticateProfileImplicitly(profile) { success, error in
                print("[\(type(of: self))] authenticateImplicitly - authenticateProfileImplicitly \(success) e: \((error?.errorDescription ?? "nil"))")
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

    func resourceRequest(isImplicit: Bool, isAnonymousCall: Bool, parameters: [String: Any], completion: @escaping FlutterDataCallback) {
        print("[\(type(of: self))] resourceRequest")
        if(isImplicit == true){
            implicitResourcesRequest(parameters, completion)
        } else{
            simpleResourcesRequest(isAnonymousCall: isAnonymousCall, parameters: parameters, completion)
        }
    }

    private func isProfileImplicitlyAuthenticated(_ profile: ONGUserProfile) -> Bool {
        print("[\(type(of: self))] isProfileImplicitlyAuthenticated")
        let implicitlyAuthenticatedProfile = ONGUserClient.sharedInstance().implicitlyAuthenticatedUserProfile()
        return implicitlyAuthenticatedProfile != nil && implicitlyAuthenticatedProfile == profile
    }

    private func authenticateProfileImplicitly(_ profile: ONGUserProfile, completion: @escaping (Bool, SdkError?) -> Void) {
        print("[\(type(of: self))] authenticateProfileImplicitly")
        ONGUserClient.sharedInstance().implicitlyAuthenticateUser(profile, scopes: nil) { success, error in
            if !success {
                let mappedError = ErrorMapper().mapError(error)
                completion(success, mappedError)
                return
            }
            completion(success, nil)
        }
    }

    private func simpleResourcesRequest(isAnonymousCall: Bool, parameters: [String: Any], _ completion: @escaping ([String: Any]?, SdkError?) -> Void) {
        print("[\(type(of: self))] simpleResourcesRequest")
        
        let encoding = getEncodingByValue(parameters["encoding"] as! String)

        let request = ONGResourceRequest.init(path: parameters["path"] as! String, method: parameters["method"] as! String, parameters: parameters["parameters"] as? [String : Any], encoding: encoding)

        let completionRequest: ((ONGResourceResponse?, Error?) -> Void)? = { response, error in
            if let error = error {
                completion(nil, SdkError(errorDescription: error.localizedDescription, code: error.code))
            } else {
                if let data = response?.data {
                    if let responseData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        completion(responseData, nil)
                    } else {
                        completion(nil, SdkError.init(customType: .failedParseData))
                    }
                } else {
                    completion(nil, SdkError.init(customType: .responseIsNull))
                }
            }
        }
        
        if isAnonymousCall {
            ONGDeviceClient.sharedInstance().fetchResource(request, completion: completionRequest)
        } else {
            ONGUserClient.sharedInstance().fetchResource(request, completion: completionRequest)
        }
    }

    private func implicitResourcesRequest(_ parameters: [String: Any], _ completion: @escaping FlutterDataCallback) {
        print("[\(type(of: self))] implicitResourcesRequest")
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
        print("[\(type(of: self))] getEncodingByValue")
        switch value {
        case "application/json":
            return ONGParametersEncoding.JSON
        case "application/x-www-form-urlencoded":
            return ONGParametersEncoding.formURL
        default:
            return ONGParametersEncoding.JSON
        }
    }
    
    //MARK: - Bridge
    func fetchAnonymousResource(_ path: String, parameters: [String: Any?], completion: @escaping FlutterResult) {
        print("[\(type(of: self))] fetchAnonymousResource")
        
        let newParameters = generateParameters(from: parameters, path: path)

        OneginiModuleSwift.sharedInstance.authenticateDeviceForResource(path) { (data) in
            guard let value = data, let _value = value as? Bool, _value else {
                completion(data)
                return
            }

            OneginiModuleSwift.sharedInstance.resourceRequest(isImplicit: false, parameters: newParameters) { (_data, error) in
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
    
    func fetchSimpleResources(_ path: String, parameters: [String: Any?], completion: @escaping FlutterResult) {
        print("[\(type(of: self))] fetchSimpleResources")
        let newParameters = generateParameters(from: parameters, path: path)

        OneginiModuleSwift.sharedInstance.resourceRequest(isImplicit: false, isAnonymousCall: false, parameters: newParameters) { (_data, error) in
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
        print("[\(type(of: self))] fetchResourceWithImplicitResource")
        guard let _profile = ONGUserClient.sharedInstance().authenticatedUserProfile() else {
            completion(SdkError.init(customType: .userProfileIsNull))
            return
        }
        
        let newParameters = generateParameters(from: parameters, path: path)
        
        OneginiModuleSwift.sharedInstance.authenticateUserImplicitly(_profile.profileId) { (value, error) in
            if (error == nil) {
                OneginiModuleSwift.sharedInstance.resourceRequest(isImplicit: value, parameters: newParameters) { (_data, error) in
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
    
    func unauthenticatedRequest(_ path: String, parameters: [String: Any?], callback: @escaping FlutterResult) {
        print("[\(type(of: self))] unauthenticatedRequest")
        
        let newParameters = generateParameters(from: parameters, path: path)
        let encoding = getEncodingByValue(newParameters["encoding"] as! String)

        let request = ONGResourceRequest.init(path: newParameters["path"] as! String, method: newParameters["method"] as! String, parameters: newParameters["parameters"] as? [String : Any], encoding: encoding)
        
        ONGDeviceClient.sharedInstance().fetchUnauthenticatedResource(request) { (_data, error) in
            if let _errorResource = error {
                callback(SdkError.convertToFlutter(SdkError.init(errorDescription: _errorResource.localizedDescription, code: _errorResource.code)))
                return
            } else {
                if let data = _data, let convertedStringDatat = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted) {
                    let convertedString = String(data: convertedStringDatat, encoding: .utf8)
                    callback(convertedString)
                } else {
                    callback(_data)
                }
            }
        }
    }
    
    func generateParameters(from parameters: [String: Any?], path: String) -> [String: Any] {
        let buffer = parameters.filter { !($0.1 is NSNull) }
        
        var newParameters = [String: Any]()
        newParameters["path"] = path
        newParameters["encoding"] = buffer["encoding"] ?? "application/x-www-form-urlencoded"
        newParameters["method"] = buffer["method"] ?? "GET"

        if let headers = buffer["headers"] {
            newParameters["headers"] = headers
        }

        if let body = buffer["body"] {
            newParameters["body"] = body
        }

        if let scope = buffer["scope"] {
            newParameters["scope"] = scope
        }
        
        return newParameters
    }
}
