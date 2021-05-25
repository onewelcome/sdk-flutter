protocol AppToWebSingleSignOnConnectorProtocol {
    func appToWebSingleSignOn(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
}

class AppToWebSingleSignOnConnector: AppToWebSingleSignOnConnectorProtocol {
    private(set) var appToWebSingleSignOnWrapper: AppToWebSingleSignOnWrapperProtocol
    
    init(wrapper: AppToWebSingleSignOnWrapperProtocol = AppToWebSingleSignOnWrapper()) {
        self.appToWebSingleSignOnWrapper = wrapper
    }
    
    func appToWebSingleSignOn(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any],
              let path = arguments[Constants.Parameters.url] as? String,
              let url = URL(string: path) else {
            result(FlutterError.from(customType: .invalidArguments))
            return
        }
        
        self.appToWebSingleSignOnWrapper.singleSignOn(targetURL: url) { (targetUrl, token, error) in
            if let error = error {
                result(FlutterError.from(error: error))
                return
            }
            
            guard let targetUrl = targetUrl, let token = token else {
                result(FlutterError.from(customType: .newSomethingWentWrong))
                return
            }
            
            result(AppToWebSingleSignOnConnector.configureResponseData(targetUrl: targetUrl, token: token))
        }
    }
    
    static func configureResponseData(targetUrl: URL, token: String) -> String {
        let jsonData = [Constants.Parameters.token: token, Constants.Parameters.redirectUrl: targetUrl.absoluteString]
        return String.stringify(json: jsonData)
    }
}
