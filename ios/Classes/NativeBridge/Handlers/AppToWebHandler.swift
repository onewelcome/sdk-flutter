import Foundation
import OneginiSDKiOS

protocol AppToWebHandlerProtocol {
    func signInAppToWeb(targetURL: URL, completion: @escaping (Result<OWAppToWebSingleSignOn, FlutterError>) -> Void)
}

class AppToWebHandler: AppToWebHandlerProtocol {
    func signInAppToWeb(targetURL: URL, completion: @escaping (Result<OWAppToWebSingleSignOn, FlutterError>) -> Void) {
        SharedUserClient.instance.appToWebSingleSignOn(with: targetURL) { (url, token, error) in
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
