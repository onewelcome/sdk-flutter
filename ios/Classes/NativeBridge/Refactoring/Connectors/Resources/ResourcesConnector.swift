import Foundation
import OneginiSDKiOS
import Flutter


protocol ResourcesConnectorProtocol {
    func fetchResources(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
}

class ResourcesConnector {
    private(set) var resourcesWrapper: ResourcesWrapperProtocol
    
    init(wrapper: ResourcesWrapperProtocol? = nil) {
        self.resourcesWrapper = wrapper ?? ResourcesWrapper()
    }
    
    //MARK: Private
    private func getEncodingByValue(_ value: String) -> ONGParametersEncoding {
        Logger.log("getEncodingByValue", sender: self)
        switch value {
        case Constants.Encoding.json:
            return ONGParametersEncoding.JSON
        case Constants.Encoding.url:
            return ONGParametersEncoding.formURL
        default:
            return ONGParametersEncoding.JSON
        }
    }

    private func generateParameters(from parameters: [String: Any?], path: String) -> [String: Any] {
        let buffer = parameters.filter { !($0.1 is NSNull) }
        
        var newParameters = [String: Any]()
        newParameters[Constants.Parameters.path] = path
        newParameters[Constants.Parameters.encoding] = buffer[Constants.Parameters.encoding] ?? Constants.Encoding.json
        newParameters[Constants.Parameters.method] = buffer[Constants.Parameters.method] ?? "GET"

        if let headers = buffer[Constants.Parameters.headers] {
            newParameters[Constants.Parameters.headers] = headers
        }

        if let body = buffer[Constants.Parameters.body] {
            newParameters[Constants.Parameters.body] = body
        }

        if let scope = buffer[Constants.Parameters.scope] {
            newParameters[Constants.Parameters.scope] = scope
        }
        
        if let parameters = buffer[Constants.Parameters.parameters] {
            newParameters[Constants.Parameters.parameters] = parameters
        }
        
        return newParameters
    }
    
    private func generateONGResourceRequest(from parameters: [String: Any]) -> ONGResourceRequest {
        let encoding = getEncodingByValue(parameters[Constants.Parameters.encoding] as! String)
        let path = parameters[Constants.Parameters.path] as! String
        let method = parameters[Constants.Parameters.method] as! String
        let headers = parameters[Constants.Parameters.headers] as? [String : String]

        var request: ONGResourceRequest!
        
        if let body = parameters[Constants.Parameters.body] as? String {
            let data = body.data(using: .utf8)
            request = ONGResourceRequest.init(path: path, method: method, body: data, headers: headers)
        } else {
            request = ONGResourceRequest.init(path:path, method: method, parameters: parameters[Constants.Parameters.parameters] as? [String : Any], encoding: encoding, headers: headers)
        }
        
        return request
    }
    
    private func implicitResourceRequest(_ request: ONGResourceRequest, parameters: [String: Any], callback: @escaping ResourcesCallbackResult, result: @escaping FlutterResult) {
        guard let userProfile = self.resourcesWrapper.authenticatedUserProfile() else {
            result(FlutterError.from(customType: .noUserAuthenticated))
            return
        }
        
        let scopes = parameters[Constants.Parameters.scope] as? [String] ?? [String]()
        self.resourcesWrapper.authenticateImplicitly(profile: userProfile, scopes: scopes) { [weak self] (success, error) in
            guard let weakSelf = self else { return }
            guard let error = error else {
                weakSelf.resourcesWrapper.implicitRequest(request, parameters: parameters, callback: callback)
                return
            }
            
            result(FlutterError.from(error: error))
        }
    }
    
    private func authenticateDeviceForResource(scopes: [String], result: @escaping FlutterResult) {
        self.resourcesWrapper.authenticateDevice(scopes: scopes) { (success, error) in
            guard let error = error else {
                result(success)
                return
            }
            result(FlutterError.from(error: error))
        }
    }
}

extension ResourcesConnector: ResourcesConnectorProtocol {
    func fetchResources(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        // 1.
        guard let arguments = call.arguments as? [String: Any],
              let path = arguments[Constants.Parameters.path] as? String else
        {
            result(FlutterError.from(customType: .invalidArguments))
            return
        }
        
        // 2.
        let parameters = generateParameters(from: arguments, path: path)
        let request = generateONGResourceRequest(from: parameters)
        
        Logger.log("Resources path: \(path), parameters: \(parameters), request's type: \(call.method)")
        
        // 3.
        let completionCallback: ResourcesCallbackResult = { response, error in
            // 1.
            if let error = error {
                result(FlutterError.from(error: error))
                return
            }
            // 2.
            guard let data = response?.data, let responseData = String.init(data: data, encoding: .utf8) else {
                result(FlutterError.from(customType: .failedParseData))
                return
            }
            
            result(responseData)
        }
        
        // 4.
        switch call.method {
        case Constants.Routes.getAnonymousResource:
            self.resourcesWrapper.anonymousRequest(request, parameters: parameters, callback: completionCallback)
        case Constants.Routes.getResource:
        self.resourcesWrapper.authenticatedRequest(request, parameters: parameters, callback: completionCallback)
        case Constants.Routes.getUnauthenticatedResource:
            self.resourcesWrapper.unauthenticatedRequest(request, parameters: parameters, callback: completionCallback)
        case Constants.Routes.getImplicitResource:
            self.implicitResourceRequest(request, parameters: parameters, callback: completionCallback, result: result)
        case Constants.Routes.authenticateDeviceForResource: do {
            let scopes = parameters[Constants.Parameters.scope] as? [String] ?? [String]()
            self.authenticateDeviceForResource(scopes: scopes, result: result)
            }
            default:
                result(FlutterError.from(customType: .invalidArguments))
        }
    }
}
