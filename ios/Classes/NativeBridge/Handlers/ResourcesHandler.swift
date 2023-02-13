import Foundation
import OneginiSDKiOS
import OneginiCrypto

typealias FlutterDataCallback = (Any?, SdkError?) -> Void

protocol FetchResourcesHandlerProtocol: AnyObject {
    func authenticateDevice(_ scopes: [String]?, completion: @escaping (Bool, SdkError?) -> Void)
    func authenticateUserImplicitly(_ profile: ONGUserProfile, scopes: [String]?, completion: @escaping (String?, SdkError?) -> Void)
    func resourceRequest(isImplicit: Bool, isAnonymousCall: Bool, parameters: [String: Any], completion: @escaping FlutterDataCallback)
    func fetchSimpleResources(_ path: String, parameters: [String: Any?], completion: @escaping FlutterResult)
    func fetchAnonymousResource(_ path: String, parameters: [String: Any?], completion: @escaping FlutterResult)
    func fetchResourceWithImplicitResource(_ path: String, parameters: [String: Any?], completion: @escaping FlutterResult)
    func unauthenticatedRequest(_ path: String, parameters: [String: Any?], callback: @escaping FlutterResult)
}

//MARK: -
class ResourcesHandler: FetchResourcesHandlerProtocol {

    func authenticateDevice(_ scopes: [String]?, completion: @escaping (Bool, SdkError?) -> Void) {
        Logger.log("authenticateDevice", sender: self)
        ONGDeviceClient.sharedInstance().authenticateDevice(scopes) { success, error in
            if let error = error {
                let mappedError = ErrorMapper().mapError(error)
                completion(success, mappedError)
            } else {
                completion(success, nil)
            }
        }
    }

    func authenticateUserImplicitly(_ profile: ONGUserProfile, scopes: [String]?, completion: @escaping (String?, SdkError?) -> Void) {
        Logger.log("authenticateImplicitly", sender: self)
        ONGUserClient.sharedInstance().implicitlyAuthenticateUser(profile, scopes: scopes) { success, error in
            if success {
                completion(profile.profileId, nil)
            } else {
                let mappedError = error.flatMap { ErrorMapper().mapError($0) } ?? SdkError(.genericError)
                completion(nil, mappedError)
            }
        }
    }

    func resourceRequest(isImplicit: Bool, isAnonymousCall: Bool, parameters: [String: Any], completion: @escaping FlutterDataCallback) {
        Logger.log("resourceRequest", sender: self)
        if(isImplicit == true){
            implicitResourcesRequest(parameters, completion)
        } else{
            simpleResourcesRequest(isAnonymousCall: isAnonymousCall, parameters: parameters, completion)
        }
    }

    private func isProfileImplicitlyAuthenticated(_ profile: ONGUserProfile) -> Bool {
        Logger.log("isProfileImplicitlyAuthenticated", sender: self)
        let implicitlyAuthenticatedProfile = ONGUserClient.sharedInstance().implicitlyAuthenticatedUserProfile()
        return implicitlyAuthenticatedProfile != nil && implicitlyAuthenticatedProfile == profile
    }

    private func authenticateProfileImplicitly(_ profile: ONGUserProfile, scopes: [String]?, completion: @escaping (Bool, SdkError?) -> Void) {
        Logger.log("authenticateProfileImplicitly", sender: self)
        ONGUserClient.sharedInstance().implicitlyAuthenticateUser(profile, scopes: scopes) { success, error in
            if !success {
                let mappedError = error.flatMap { ErrorMapper().mapError($0) } ?? SdkError(.genericError)
                completion(success, mappedError)
                return
            }
            completion(success, nil)
        }
    }

    private func simpleResourcesRequest(isAnonymousCall: Bool, parameters: [String: Any], _ completion: @escaping (Any?, SdkError?) -> Void) {
        Logger.log("simpleResourcesRequest", sender: self)
        let request = generateONGResourceRequest(from: parameters)

        let completionRequest: ((ONGResourceResponse?, Error?) -> Void)? = { response, error in
            if let error = error {
                if response != nil {
                    completion(nil, SdkError(.errorCodeHttpRequest, response: response, iosCode: error.code, iosMessage: error.localizedDescription))
                } else {
                    completion(nil, SdkError(.httpRequestError, response: response, iosCode: error.code, iosMessage: error.localizedDescription))
                }
            } else {
                if let response = response, let _ = response.data {
                    completion(response.toString(), nil)
                } else {
                    completion(nil, SdkError(.responseIsNull))
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
        Logger.log("implicitResourcesRequest", sender: self)

        let request = generateONGResourceRequest(from: parameters)

        ONGUserClient.sharedInstance().fetchImplicitResource(request) { response, error in
            if let error = error {
                if response != nil {
                    completion(nil, SdkError(.errorCodeHttpRequest, response: response, iosCode: error.code, iosMessage: error.localizedDescription))
                } else {
                    completion(nil, SdkError(.httpRequestError, response: response, iosCode: error.code, iosMessage: error.localizedDescription))
                }
            } else {
                if let response = response, let _ = response.data {
                    completion(response.toString(), nil)
                } else {
                    completion(nil, SdkError(.responseIsNull))
                }
            }
        }
    }

    private func getEncodingByValue(_ value: String) -> ONGParametersEncoding {
        Logger.log("getEncodingByValue", sender: self)
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
        Logger.log("fetchAnonymousResource", sender: self)
        
        let newParameters = generateParameters(from: parameters, path: path)

        OneginiModuleSwift.sharedInstance.resourceRequest(isImplicit: false, parameters: newParameters) { (data, error) in
            if let _errorResource = error {
                completion(_errorResource)
                return
            } else {
                completion(data)
            }
        }
    }

    func fetchSimpleResources(_ path: String, parameters: [String: Any?], completion: @escaping FlutterResult) {
        Logger.log("fetchSimpleResources", sender: self)
        let newParameters = generateParameters(from: parameters, path: path)
        OneginiModuleSwift.sharedInstance.resourceRequest(isImplicit: false, isAnonymousCall: false, parameters: newParameters) { (_data, error) in
            if let _errorResource = error {
                completion(_errorResource)
                return
            } else {
                completion(_data)
            }
        }
    }

    func fetchResourceWithImplicitResource(_ path: String, parameters: [String: Any?], completion: @escaping FlutterResult) {
        Logger.log("fetchResourceWithImplicitResource", sender: self)
        guard let _ = ONGUserClient.sharedInstance().implicitlyAuthenticatedUserProfile() else {
            completion(SdkError(.unauthenticatedImplicitly).flutterError())
            return
        }

        let newParameters = generateParameters(from: parameters, path: path)
        let scopes = newParameters["scope"] as? [String]
        
        OneginiModuleSwift.sharedInstance.resourceRequest(isImplicit: true, parameters: newParameters) { (data, error) in
            completion(data ?? error)
        }
    }

    func unauthenticatedRequest(_ path: String, parameters: [String: Any?], callback: @escaping FlutterResult) {
        Logger.log("unauthenticatedRequest", sender: self)

        let newParameters = generateParameters(from: parameters, path: path)

        let request = generateONGResourceRequest(from: newParameters)

        ONGDeviceClient.sharedInstance().fetchUnauthenticatedResource(request) { (response, error) in
            if let _errorResource = error {
                if response != nil {
                    callback(SdkError.convertToFlutter(SdkError(.errorCodeHttpRequest, response: response, iosCode: _errorResource.code, iosMessage: _errorResource.localizedDescription)))
                } else {
                    callback(SdkError.convertToFlutter(SdkError(.httpRequestError, response: response, iosCode: _errorResource.code, iosMessage: _errorResource.localizedDescription)))
                }
                return
            } else {
                if let response = response, let data = response.data {
                    if let _ = String(data: data, encoding: .utf8) {
                        callback(response.toString())
                    } else {
                        callback(data)
                    }
                } else {
                    callback(SdkError(.responseIsNull))
                }
            }
        }
    }

    func generateParameters(from parameters: [String: Any?], path: String) -> [String: Any] {
        let buffer = parameters.filter { !($0.1 is NSNull) }
        
        var newParameters = [String: Any]()
        newParameters["path"] = path
        newParameters["encoding"] = buffer["encoding"] ?? "application/json"
        newParameters["method"] = buffer["method"] ?? "GET"

        if let headers = buffer["headers"] {
            newParameters["headers"] = headers
        }

        if let body = buffer["body"] {
            newParameters["body"] = body
        }
        
        if let parameters = buffer["parameters"] {
            newParameters["parameters"] = parameters
        }
        
        return newParameters
    }

    func generateONGResourceRequest(from parameters: [String: Any]) -> ONGResourceRequest {
        let encoding = getEncodingByValue(parameters["encoding"] as! String)
        let path = parameters["path"] as! String
        let method = parameters["method"] as! String
        let headers = parameters["headers"] as? [String : String]

        var request: ONGResourceRequest!
        
        if let body = parameters["body"] as? String {
            let data = body.data(using: .utf8)
            request = ONGResourceRequest.init(path: path, method: method, body: data, headers: headers)
        } else {
            request = ONGResourceRequest.init(path:path, method: method, parameters: parameters["parameters"] as? [String : Any], encoding: encoding, headers: headers)
        }

        return request
    }
}

extension ONGResourceResponse {
    func toJSON() -> Dictionary<String, Any?> {
        return ["statusCode": statusCode,
                "headers": allHeaderFields,
                "url": rawResponse.url?.absoluteString,
                "body": data != nil ? String(data: data!, encoding: .utf8) : nil
        ]
    }

    func toString() -> String {
        return String.stringify(json: self.toJSON())
    }
}
