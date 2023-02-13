import OneginiSDKiOS
import OneginiCrypto

enum OneWelcomeWrapperError: Int {
    // iOS and Android
    case genericError = 8000
    case userProfileIsNull = 8001
    case authenticatedUserProfileIsNull = 8002
    case authenticatorNotFound = 8004
    case httpRequestError = 8011
    case errorCodeHttpRequest = 8013
    case unauthenticatedImplicitly = 8035
    
    // iOS only
    case providedUrlIncorrect = 8014
    case loginCanceled = 8015
    case enrollmentFailed = 8016
    case authenticationCancelled = 8017
    case changingPinCancelled = 8018
    case registrationCancelled = 8020
    case cantHandleOTP = 8021
    case incorrectResourcesAccess = 8022
    case authenticatorNotRegistered = 8023
    case authenticatorDeregistrationCancelled = 8024
    case failedToParseData = 8025
    case responseIsNull = 8026
    case authenticatorIdIsNull = 8027
    case emptyInputValue = 8028
    case unsupportedPinAction = 8029
    case unsupportedCustomRegistrationAction = 8030
    case authenticatorRegistrationCancelled = 8031

    func message() -> String {
        var message = ""
        
        switch self {
        case .genericError:
            message = "Something went wrong."
        case .userProfileIsNull:
            message = "User profile is null."
        case .authenticatedUserProfileIsNull:
            message = "User authenticated profile is null."
        case .authenticatorNotFound:
            message = "The requested authenticator is not found"
        case .providedUrlIncorrect:
            message = "Provided url is incorrect."
        case .enrollmentFailed:
            message = "Enrollment failed. Please try again or contact maintainer."
        case .loginCanceled:
            message = "Login cancelled."
        case .authenticationCancelled:
            message = "Authentication cancelled."
        case .authenticatorDeregistrationCancelled:
            message = "Authenticator deregistration cancelled."
        case .changingPinCancelled:
            message = "Changing pin cancelled."
        case .registrationCancelled:
            message = "Registration cancelled."
        case .cantHandleOTP:
            message = "Can't handle otp authentication request."
        case .incorrectResourcesAccess:
            message = "Incorrect access to resources."
        case .authenticatorNotRegistered:
            message = "This authenticator is not registered."
        case .failedToParseData:
            message = "Failed to parse data."
        case .responseIsNull:
            message = "Response doesn't contain data."
        case .authenticatorIdIsNull:
            message = "Authenticator ID is empty."
        case .emptyInputValue:
            message = "Empty input value."
        case .errorCodeHttpRequest:
            message = "OneWelcome: HTTP Request failed. Check Response for more info."
        case .httpRequestError:
            message = "OneWelcome: HTTP Request failed. Check iosCode and iosMessage for more info."
        case .unsupportedPinAction:
            message = "Unsupported pin action. Contact SDK maintainer."
        case .unsupportedCustomRegistrationAction:
            message = "Unsupported custom registration action. Contact SDK maintainer."
        case .authenticatorRegistrationCancelled:
            message = "The authenticator-registration was cancelled."
        case .unauthenticatedImplicitly:
            message = "The requested action requires you to be authenticated implicitly"
        default:
            message = "Something went wrong."
        }
        
        return message
    }
}

class ErrorMapper {
    func mapError(_ error: Error, pinChallenge: ONGPinChallenge? = nil, customInfo: ONGCustomInfo? = nil) -> SdkError {
        Logger.log("Error domain: \(error.domain)")
        
        return SdkError(code: error.code, errorDescription: error.localizedDescription)
    }
    
    func mapErrorFromPinChallenge(_ challenge: ONGPinChallenge?) -> SdkError? {
        if let error = challenge?.error, error.code != ONGAuthenticationError.touchIDAuthenticatorFailure.rawValue {
            guard let maxAttempts = challenge?.maxFailureCount,
                  let previousCount = challenge?.previousFailureCount,
                  maxAttempts != previousCount else {
                return ErrorMapper().mapError(error, pinChallenge: challenge)
            }
            return SdkError(code: error.code, errorDescription: "Failed attempts", info: ["failedAttempts": previousCount, "maxAttempts": maxAttempts])
        } else {
            return nil
        }
    }
}

