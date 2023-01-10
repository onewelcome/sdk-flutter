import Foundation
import OneginiSDKiOS
import OneginiCrypto

//MARK: -
protocol AppToWebHandlerProtocol: AnyObject {
    func signInAppToWeb(targetURL: URL?, completion: @escaping (Dictionary<String, Any>?, SdkError?) -> Void)
}

//MARK: - 
class AppToWebHandler: AppToWebHandlerProtocol {
    func signInAppToWeb(targetURL: URL?, completion: @escaping (Dictionary<String, Any>?, SdkError?) -> Void) {
        guard let _targetURL = targetURL else {
            completion(nil, SdkError.init(wrapperError: .providedUrlIncorrect))
            return
        }

        ONGUserClient.sharedInstance()
            .appToWebSingleSignOn(withTargetUrl: _targetURL) { (url, token, error) in
            if let _url = url, let _token = token {
                completion(["token": _token, "redirectUrl": _url.absoluteString ], nil)
            } else if let _error = error {
                // Handle error
                let sdkError = SdkError(errorDescription: _error.localizedDescription)
                completion(nil, sdkError)
            }
        }
    }
}
