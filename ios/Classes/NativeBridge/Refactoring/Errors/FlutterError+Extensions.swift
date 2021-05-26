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
    
    class func fromPinChallenge(_ challenge: ONGPinChallenge?) -> Error? {
        guard let challenge = challenge, var error = challenge.error, error.code != ONGAuthenticationError.touchIDAuthenticatorFailure.rawValue else {
            return nil
        }
        
        let maxAttempts = challenge.maxFailureCount
        let previousCount = challenge.previousFailureCount
        
        guard maxAttempts != previousCount else {
            return error
        }
        
        error.userInfo = [Constants.Parameters.failedAttempts: previousCount, Constants.Parameters.maxAttempts: maxAttempts]
        return error
    }
}


