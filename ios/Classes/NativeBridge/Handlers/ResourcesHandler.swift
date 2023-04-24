import Foundation
import OneginiSDKiOS

typealias FlutterDataCallback = (Any?, SdkError?) -> Void

protocol FetchResourcesHandlerProtocol: AnyObject {
    func authenticateDevice(_ scopes: [String]?, completion: @escaping (Result<Void, FlutterError>) -> Void)
    func authenticateUserImplicitly(_ profile: ONGUserProfile, scopes: [String]?, completion: @escaping (Result<Void, FlutterError>) -> Void)
    func requestResource(_ type: ResourceRequestType, _ details: OWRequestDetails, completion: @escaping (Result<OWRequestResponse, FlutterError>) -> Void)
}

// MARK: -
class ResourcesHandler: FetchResourcesHandlerProtocol {

    func authenticateDevice(_ scopes: [String]?, completion: @escaping (Result<Void, FlutterError>) -> Void) {
        Logger.log("authenticateDevice", sender: self)
        ONGDeviceClient.sharedInstance().authenticateDevice(scopes) { _, error in
            if let error = error {
                let mappedError = FlutterError(ErrorMapper().mapError(error))
                completion(.failure(mappedError))
            } else {
                completion(.success)
            }
        }
    }

    func authenticateUserImplicitly(_ profile: ONGUserProfile, scopes: [String]?, completion: @escaping (Result<Void, FlutterError>) -> Void) {
        Logger.log("authenticateImplicitly", sender: self)
        ONGUserClient.sharedInstance().implicitlyAuthenticateUser(profile, scopes: scopes) { success, error in
            if success {
                completion(.success)
            } else {
                // This error construction is obviously not good, but it will work for now till we refactor this later
                let mappedError = FlutterError(error.flatMap { ErrorMapper().mapError($0) } ?? SdkError(.genericError))
                completion(.failure(mappedError))
            }
        }
    }

    func requestResource(_ requestType: ResourceRequestType, _ details: OWRequestDetails, completion: @escaping (Result<OWRequestResponse, FlutterError>) -> Void) {
        Logger.log("requestResource", sender: self)

        let request = generateONGResourceRequest(details)
        let requestCompletion = getRequestCompletion(completion)

        switch requestType {
        case ResourceRequestType.implicit:
            // For consistency with Android we perform this step
            if ONGUserClient.sharedInstance().implicitlyAuthenticatedUserProfile() == nil {
                completion(.failure(FlutterError(SdkError(.notAuthenticatedImplicit))))
                return
            }

            ONGUserClient.sharedInstance().fetchImplicitResource(request, completion: requestCompletion)
        case ResourceRequestType.anonymous:
            ONGDeviceClient.sharedInstance().fetchResource(request, completion: requestCompletion)
        case ResourceRequestType.authenticated:
            ONGUserClient.sharedInstance().fetchResource(request, completion: requestCompletion)
        case ResourceRequestType.unauthenticated:
            ONGDeviceClient.sharedInstance().fetchUnauthenticatedResource(request, completion: requestCompletion)
        }
    }
}

private extension ResourcesHandler {
    func generateONGResourceRequest(_ details: OWRequestDetails) -> ONGResourceRequest {
        Logger.log("generateONGResourceRequest", sender: self)
        return ONGResourceRequest(path: details.path,
                                  method: details.method.stringValue,
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

    func getRequestCompletion(_ completion: @escaping (Result<OWRequestResponse, FlutterError>) -> Void) -> ((ONGResourceResponse?, Error?) -> Void)? {
        Logger.log("getCompletionRequest", sender: self)
        let completionRequest: ((ONGResourceResponse?, Error?) -> Void)? = { response, error in
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
    var stringValue: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        case .delete: return "DELETE"
        case .put: return "PUT"
        }
    }
}
