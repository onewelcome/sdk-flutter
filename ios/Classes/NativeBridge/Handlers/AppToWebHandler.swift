import Foundation
import OneginiSDKiOS

// MARK: -
protocol AppToWebHandlerProtocol: AnyObject {
    func signInAppToWeb(targetURL: URL, completion: @escaping (Result<OWAppToWebSingleSignOn, FlutterError>) -> Void)
}

// MARK: - 
class AppToWebHandler: AppToWebHandlerProtocol {
    func signInAppToWeb(targetURL: URL, completion: @escaping (Result<OWAppToWebSingleSignOn, FlutterError>) -> Void) {
        ONGUserClient.sharedInstance().appToWebSingleSignOn(withTargetUrl: targetURL) { (url, token, error) in
            if let url = url, let token = token {
                completion(.success(OWAppToWebSingleSignOn(token: token, redirectUrl: url.absoluteString)))
            } else if let error = error {
                completion(.failure(SdkError(code: error.code, errorDescription: error.localizedDescription).flutterError()))
            } else {
                completion(.failure(SdkError(.genericError).flutterError()))
            }
        }
    }
}
