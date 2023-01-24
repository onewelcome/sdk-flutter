import OneginiSDKiOS
import OneginiCrypto

enum OneWelcomeWrapperError: Int {
    // iOS and Android
    case genericError = 8000
    case userProfileIsNullError = 8001
    case authenticatedUserProfileIsNullError = 8002
    case authenticatorNotFoundError = 8004
    case httpRequestError = 8011
    case errorCodeHttpRequestError = 8013
    
    // iOS only
    case providedUrlIncorrectError = 8014
    case loginCanceledError = 8015
    case enrollmentFailedError = 8016
    case authenticationCancelledError = 8017
    case changingCancelledError = 8018
    case registrationCancelledError = 8020
    case cantHandleOTPError = 8021
    case incorrectResourcesAccessError = 8022
    case authenticatorNotRegisteredError = 8023
    case authenticatorDeregistrationCancelledError = 8024
    case failedToParseDataError = 8025
    case responseIsNullError = 8026
    case authenticatorIdIsNullError = 8027
    case emptyInputValueError = 8028
    case unsupportedPinActionError = 8029
    case unsupportedCustomRegistrationActionError = 8030
    case authenticatorRegistrationCancelled = 8031

    func message() -> String {
        var message = ""
        
        switch self {
        case .genericError:
            message = "Something went wrong."
        case .userProfileIsNullError:
            message = "User profile is null."
        case .authenticatedUserProfileIsNullError:
            message = "User authenticated profile is null."
        case .authenticatorNotFoundError:
            message = "The requested authenticator is not found"
        case .providedUrlIncorrectError:
            message = "Provided url is incorrect."
        case .enrollmentFailedError:
            message = "Enrollment failed. Please try again or contact maintainer."
        case .loginCanceledError:
            message = "Login cancelled."
        case .authenticationCancelledError:
            message = "Authentication cancelled."
        case .authenticatorDeregistrationCancelledError:
            message = "Authenticator deregistration cancelled."
        case .changingCancelledError:
            message = "Changing cancelled."
        case .registrationCancelledError:
            message = "Registration cancelled."
        case .cantHandleOTPError:
            message = "Can't handle otp authentication request."
        case .incorrectResourcesAccessError:
            message = "Incorrect access to resources."
        case .authenticatorNotRegisteredError:
            message = "This authenticator is not registered."
        case .failedToParseDataError:
            message = "Failed to parse data."
        case .responseIsNullError:
            message = "Response doesn't contain data."
        case .authenticatorIdIsNullError:
            message = "Authenticator ID is empty."
        case .emptyInputValueError:
            message = "Empty input value."
        case .errorCodeHttpRequestError:
            message = "OneWelcome: HTTP Request failed. Check Response for more info."
        case .httpRequestError:
            message = "OneWelcome: HTTP Request failed. Check iosCode and iosMessage for more info."
        case .unsupportedPinActionError:
            message = "Unsupported pin action. Contact SDK maintainer."
        case .unsupportedCustomRegistrationActionError:
            message = "Unsupported custom registration action. Contact SDK maintainer."
        case .authenticatorRegistrationCancelled:
            message = "The authenticator-registration was cancelled."
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

