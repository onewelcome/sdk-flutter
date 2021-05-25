import OneginiSDKiOS
import Flutter

typealias AppToWebSingleSignOnCallbackResult = (URL?, String?, Error?) -> Void

protocol AppToWebSingleSignOnWrapperProtocol {
    func singleSignOn(targetURL: URL, completion: @escaping AppToWebSingleSignOnCallbackResult) -> Void
}

class AppToWebSingleSignOnWrapper: AppToWebSingleSignOnWrapperProtocol {
    func singleSignOn(targetURL: URL, completion: @escaping AppToWebSingleSignOnCallbackResult) {
        ONGUserClient.sharedInstance()
            .appToWebSingleSignOn(withTargetUrl: targetURL, completion: completion)
    }
}

