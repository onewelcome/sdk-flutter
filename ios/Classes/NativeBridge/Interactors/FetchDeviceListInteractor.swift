import UIKit
import OneginiSDKiOS
import OneginiCrypto

protocol FetchDeviceListInteractorProtocol: AnyObject {
    func fetchDeviceList(completion: @escaping FlutterDataCallback)
}

class FetchDeviceListInteractor: FetchDeviceListInteractorProtocol {

    func fetchDeviceList(completion: @escaping(Any?, SdkError?) -> Void) {
        let request = ONGResourceRequest(path: "/devices", method: "GET")
        ONGUserClient.sharedInstance().fetchResource(request) { response, error in
            
            if let error = error {
                let mappedError = ErrorMapper().mapError(error)
                completion(nil, mappedError)
            } else {
                if let data = response?.data, let convertedString = String(data: data, encoding: String.Encoding.utf8)
                   {
                    completion(convertedString, nil)
                } else {
                    completion(nil, nil)
                }
            }
        }
    }
}

