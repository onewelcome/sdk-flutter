import Foundation
import OneginiSDKiOS

typealias FlutterDataCallback = (Any?, SdkError?) -> Void

protocol FetchResourcesHandlerProtocol: AnyObject {
    func authenticateDevice(_ scopes: [String]?, completion: @escaping (Result<Void, FlutterError>) -> Void)
    func authenticateUserImplicitly(_ profile: UserProfile, scopes: [String]?, completion: @escaping (Result<Void, FlutterError>) -> Void)
    func requestResource(_ type: ResourceRequestType, _ details: OWRequestDetails, completion: @escaping (Result<OWRequestResponse, FlutterError>) -> Void)
}

// MARK: -
class ResourcesHandler: FetchResourcesHandlerProtocol {

    func authenticateDevice(_ scopes: [String]?, completion: @escaping (Result<Void, FlutterError>) -> Void) {
        Logger.log("authenticateDevice", sender: self)
        SharedDeviceClient.instance.authenticateDevice(with: scopes) { error in
            if let error = error {
                let mappedError = FlutterError(ErrorMapper().mapError(error))
                completion(.failure(mappedError))
            } else {
                completion(.success)
            }
        }
    }

    func authenticateUserImplicitly(_ profile: UserProfile, scopes: [String]?, completion: @escaping (Result<Void, FlutterError>) -> Void) {
        Logger.log("authenticateUserImplicitly", sender: self)
        SharedUserClient.instance.implicitlyAuthenticate(user: profile, with: scopes) { error in
            if let error = error {
                let mappedError = FlutterError(ErrorMapper().mapError(error))
                completion(.failure(mappedError))
            } else {
                completion(.success)
            }
        }
    }

    func requestResource(_ requestType: ResourceRequestType, _ details: OWRequestDetails, completion: @escaping (Result<OWRequestResponse, FlutterError>) -> Void) {
        Logger.log("requestResource", sender: self)
        // Additional check for valid url
        let resourceUrl = ONGClient.sharedInstance().configModel.resourceBaseURL ?? ""
        if isValidUrl(details.path) == false && isValidUrl(resourceUrl + details.path) == false {
            completion(.failure(FlutterError(SdkError(.invalidUrl))))
            return
        }

        let request = generateResourceRequest(details)
        let requestCompletion = getRequestCompletion(completion)

        switch requestType {
        case ResourceRequestType.implicit:
            // For consistency with Android we perform this step
            if SharedUserClient.instance.implicitlyAuthenticatedUserProfile == nil {
                completion(.failure(FlutterError(SdkError(.notAuthenticatedImplicit))))
                return
            }
            SharedUserClient.instance.sendImplicitRequest(request, completion: requestCompletion)
        case ResourceRequestType.anonymous:
            SharedDeviceClient.instance.sendRequest(request, completion: requestCompletion)
        case ResourceRequestType.authenticated:
            SharedUserClient.instance.sendAuthenticatedRequest(request, completion: requestCompletion)
        case ResourceRequestType.unauthenticated:
            SharedDeviceClient.instance.sendUnauthenticatedRequest(request, completion: requestCompletion)
        }
    }
}

private extension ResourcesHandler {
    func isValidUrl(_ path: String) -> Bool {
        if let url = URL(string: path) {
            return UIApplication.shared.canOpenURL(url)
        }

        return false
    }

    func generateResourceRequest(_ details: OWRequestDetails) -> ResourceRequest {
        Logger.log("generateResourceRequest", sender: self)

        return ResourceRequestFactory.makeResourceRequest(path: details.path,
                                  method: details.method.toHTTPMethod(),
                                  body: details.body?.data(using: .utf8),
                                  headers: getRequestHeaders(details.headers)
                                 )
    }

    func getRequestHeaders(_ headers: [String?: String?]?) -> [String: String]? {
        // Pigeon 9.0.5 limits enforcing non null values in maps; from Flutter we only pass [String: String]
        Logger.log("getRequestHeaders", sender: self)
        guard let headers = headers else { return nil }

        return headers.filter { $0.key != nil && $0.value != nil } as? [String: String]
    }

    func getRequestCompletion(_ completion: @escaping (Result<OWRequestResponse, FlutterError>) -> Void) -> ((ResourceResponse?, Error?) -> Void) {
        Logger.log("getCompletionRequest", sender: self)
        let completionRequest: ((ResourceResponse?, Error?) -> Void) = { response, error in
            if let error = error {
                if response != nil {
                    let flutterError = FlutterError(SdkError(.httpRequestErrorCode, response: response, iosCode: error.code, iosMessage: error.localizedDescription))
                    completion(.failure(flutterError))
                } else {
                    let flutterError = FlutterError(SdkError(.httpRequestErrorInternal, response: response, iosCode: error.code, iosMessage: error.localizedDescription))
                    completion(.failure(flutterError))
                }
            } else {
                if let response = response {
                    completion(.success(OWRequestResponse(response)))
                } else {
                    completion(.failure(FlutterError(SdkError(.httpRequestErrorNoResponse))))
                }
            }
        }

        return completionRequest
    }
}

private extension HttpRequestMethod {
    func toHTTPMethod() -> HTTPMethod {
        switch self {
        case .get: return .get
        case .post: return .post
        case .delete: return .delete
        case .put: return .put
        }
    }
}
