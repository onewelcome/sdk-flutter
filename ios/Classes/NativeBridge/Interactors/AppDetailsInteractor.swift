import UIKit
import OneginiSDKiOS
import OneginiCrypto

protocol AppDetailsInteractorProtocol: AnyObject {
    func fetchAppDetails(completion: @escaping(Any?, SdkError?) -> Void)
}

class AppDetailsInteractor: AppDetailsInteractorProtocol {
    let decoder = JSONDecoder()

    func fetchAppDetails(completion: @escaping(Any?, SdkError?) -> Void) {
        let resourceRequest = ONGResourceRequest(path: "/application-details", method: "GET")
        ONGDeviceClient.sharedInstance().fetchResource(resourceRequest) { response, error in
            if let error = error {
                let mappedError = ErrorMapper().mapError(error)
                completion(nil, mappedError)
            } else {
                if let data = response?.data, let convertedString = String(data: data, encoding: String.Encoding.utf8) {
                    if let _ = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        completion(convertedString, nil)
                    }
                }
            }
        }
    }
}
