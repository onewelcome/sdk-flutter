import UIKit
import OneginiSDKiOS
import OneginiCrypto

protocol AppDetailsInteractorProtocol: AnyObject {
    func fetchAppDetails(completion: @escaping(Any?, SdkError?) -> Void)
}

class AppDetailsInteractor: AppDetailsInteractorProtocol {
    //weak var appDetailsPresenter: AppDetailsInteractorToPresenterProtocol?
    let decoder = JSONDecoder()

    func fetchAppDetails(completion: @escaping(Any?, SdkError?) -> Void) {
        authenticateDevice(completion: { success, error in
            if success {
                self.deviceResourcesRequest(completion: { applicationDetails, error in
                    if let applicationDetails = applicationDetails {
                        completion(applicationDetails, nil)
                    } else if let error = error {
                        completion(nil, error)
                    }
                })
            } else if let error = error {
                completion(nil, error)
            }
        })
    }

    func authenticateDevice(completion: @escaping (Bool, SdkError?) -> Void) {
        ONGDeviceClient.sharedInstance().authenticateDevice(["application-details"]) { success, error in
            if let error = error {
                let mappedError = ErrorMapper().mapError(error)
                completion(success, mappedError)
            } else {
                completion(success, nil)
            }
        }
    }

    fileprivate func deviceResourcesRequest(completion: @escaping (Any?, SdkError?) -> Void) {
        let resourceRequest = ONGResourceRequest(path: "/application-details", method: "GET")
        ONGDeviceClient.sharedInstance().fetchResource(resourceRequest) { response, error in
            if let error = error {
                let mappedError = ErrorMapper().mapError(error)
                completion(nil, mappedError)
            } else {
                if let data = response?.data, let convertedString = String(data: data, encoding: String.Encoding.utf8) {
                    if let appDetails = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        print(appDetails)
                        completion(convertedString, nil)
                    }
                }
            }
        }
    }
}

struct ApplicationDetails: Codable {
    private enum CodingKeys: String, CodingKey {
        case appId = "application_identifier"
        case appVersion = "application_version"
        case appPlatform = "application_platform"
    }

    let appId: String
    let appVersion: String
    let appPlatform: String
}
