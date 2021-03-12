import Foundation
import OneginiSDKiOS
import OneginiCrypto

protocol AppToWebHandlerProtocol: AnyObject {
    func signInAppToWeb(targetURL: URL?, completion: @escaping (Dictionary<String, Any>?, SdkError?) -> Void)
}

class AppToWebHandler: AppToWebHandlerProtocol {
    func signInAppToWeb(targetURL: URL?, completion: @escaping (Dictionary<String, Any>?, SdkError?) -> Void) {
        guard let _targetURL = targetURL else {
            completion(nil, SdkError.init(customType: .providedUrlIncorrect))
            return
        }

        ONGUserClient.sharedInstance()
            .appToWebSingleSignOn(withTargetUrl: _targetURL) { (url, token, error) in
            if let _url = url, let _token = token {
                completion(["token": _token, "url": _url.absoluteString ], nil)
            } else if let _error = error {
                // Handle error
                debugPrint(_error)

                let sdkError = SdkError(errorDescription: _error.localizedDescription)
                completion(nil, sdkError)
            }
        }
    }
}
