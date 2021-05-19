import Foundation
import OneginiSDKiOS

extension FlutterError {
    
    class func from(error: Error) -> FlutterError {
        let domain = (error as NSError).domain
        let code: Int = (error as NSError).code
        let userInfo: Dictionary<String, Any> = (error as NSError).userInfo
        let localizedDescription = error.localizedDescription
        let recoverySuggestion = (error as NSError).localizedRecoverySuggestion ?? ""
        
        let details = ["message": localizedDescription,
                       "recoverySuggestion": recoverySuggestion,
                       "code": code,
                       "domain": domain,
                       "userInfo": userInfo] as [String : Any]
        
        let flutterError = FlutterError(code: "\(code)", message: localizedDescription, details: details)

        return flutterError
    }

    class func from(customType: PluginErrorType = .newSomethingWentWrong) -> FlutterError {
        let flutterError = FlutterError(code: "\(customType.rawValue)", message: customType.errorDescription, details: nil)

        return flutterError
    }
}
