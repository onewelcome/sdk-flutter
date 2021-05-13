import OneginiSDKiOS
import OneginiCrypto

enum OneginiErrorCustomType: Int {
    case userProfileIsNull = 8002
    case userAuthenticatedProfileIsNull
    case registeredAuthenticatorsIsNull
    case notRegisteredAuthenticatorsIsNull
    case identityProvidersIsNull
    case providedUrlIncorrect
    case loginCanceled
    case enrollmentFailed
    case authenticationCancelled
    case changingCancelled
    case registrationCancelled
    case cantHandleOTP
    case incrorrectResourcesAccess
    case authenticatorNotAvailable
    case authenticatorNotRegistered
    case authenticatorDeregistrationCancelled
    case failedParseData
    case responseIsNull
    case authenticatorIdIsNull
    case emptyInputValue
    // Default case
    case somethingWentWrong = 400
    
    func message() -> String {
        var message = ""
        
        switch self {
        case .userProfileIsNull:
            message = "User profile is empty."
        case .userAuthenticatedProfileIsNull:
            message = "User authenticated profile is empty."
        case .registeredAuthenticatorsIsNull:
            message = "List Registered authenticators is empty."
        case .notRegisteredAuthenticatorsIsNull:
            message = "List Not Registered authenticators is empty."
        case .identityProvidersIsNull:
            message = "Identity providers is empty."
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
        case .changingCancelled:
            message = "Changing cancelled."
        case .registrationCancelled:
            message = "Registration  cancelled."
        case .cantHandleOTP:
            message = "Can't handle otp authentication request."
        case .incrorrectResourcesAccess:
            message = "Incorrect access to resources."
        case .authenticatorNotAvailable:
            message = "This authenticator is not available."
        case .authenticatorNotRegistered:
            message = "This authenticator is not registered."
        case .failedParseData:
            message = "Failed to parse data."
        case .responseIsNull:
            message = "Response doesn't contain data."
        case .authenticatorIdIsNull:
            message = "Authenticator ID is empty."
        case .emptyInputValue:
            message = "Empty input value."
        default:
            message = "Something went wrong."
        }
        
        return message
    }
}

class ErrorMapper {
    func mapError(_ error: Error, pinChallenge: ONGPinChallenge? = nil, customInfo: ONGCustomInfo? = nil) -> SdkError {
        print("Error domain: ", error.domain)
        
        return SdkError(errorDescription: error.localizedDescription, code: error.code)
    }
    
    func mapErrorFromPinChallenge(_ challenge: ONGPinChallenge?) -> SdkError? {
        if let error = challenge?.error, error.code != ONGAuthenticationError.touchIDAuthenticatorFailure.rawValue {
            guard let maxAttempts = challenge?.maxFailureCount,
                  let previousCount = challenge?.previousFailureCount,
                  maxAttempts != previousCount else {
                return ErrorMapper().mapError(error, pinChallenge: challenge)
            }
            return SdkError(errorDescription: "Failed attempts", code: error.code, info: ["failedAttempts": previousCount, "maxAttempts": maxAttempts])
        } else {
            return nil
        }
    }
}

