import OneginiSDKiOS
import OneginiCrypto

enum OneginiErrorCustomType: Int {
    case userProfileIsNull = 8002
    case fingerprintAuthenticatorIsNull
    case registeredAuthenticatorsIsNull
    case identityProvidersIsNull
    case providedUrlIncorrect
    case loginCanceled
    case enrollmentFailed
    case authenticationCancelled
    case changingCancelled
    case registrationCancelled
    // Default case
    case somethingWentWrong = 400
    
    func message() -> String {
        var message = ""
        
        switch self {
        case .userProfileIsNull:
            message = ""
        case .fingerprintAuthenticatorIsNull:
            message = "Fingerprint authenticator is null."
        case .registeredAuthenticatorsIsNull:
            message = "Registered authenticators is null."
        case .identityProvidersIsNull:
            message = "Identity providers is null."
        case .providedUrlIncorrect:
            message = "Provided url is incorrect."
        case .enrollmentFailed:
            message = "Enrollment failed. Please try again or contact maintainer."
        case .loginCanceled:
            message = "Login cancelled."
        case .authenticationCancelled:
            message = "Authentication cancelled."
        case .changingCancelled:
            message = "Changing cancelled."
        case .registrationCancelled:
            message = "Registration  cancelled."
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
}

