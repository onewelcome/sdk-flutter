// swiftlint:disable cyclomatic_complexity
import OneginiSDKiOS

enum OneWelcomeWrapperError {
    case genericError
    case doesNotExistUserProfile
    case notAuthenticatedUser
    case notAuthenticatedImplicit
    case notFoundAuthenticator
    case httpRequestErrorInternal
    case httpRequestErrorCode
    case httpRequestErrorNoResponse // ios only
    case providedUrlIncorrect // ios only
    case enrollmentFailed // ios only
    case processCanceledLogin // ios only
    case processCanceledAuthentication // ios only
    case processCanceledRegistration // ios only
    case processCanceledAuthenticatorDeregistration // ios only
    case processCanceledAuthenticatorRegistration // ios only
    case authenticatorNotRegistered // ios only
    case notInProgressRegistration
    case notInProgressAuthentication
    case notInProgressOtpAuthentication
    case notInProgressPinCreation
    case alreadyInProgressMobileAuth // ios only
    case actionNotAllowedCustomRegistrationCancel
    case actionNotAllowedCustomRegistrationSubmit
    case actionNotAllowedBrowserRegistrationCancel

    func code() -> Int {
        switch self {
        case .genericError:
            return 8000
        case .doesNotExistUserProfile:
            return 8001
        case .notAuthenticatedUser, .notAuthenticatedImplicit:
            return 8002
        case .notFoundAuthenticator:
            return 8004
        case .httpRequestErrorInternal, .httpRequestErrorCode, .httpRequestErrorNoResponse:
            return 8011
        case .providedUrlIncorrect:
            return 8014
        case .enrollmentFailed:
            return 8016
        case .processCanceledAuthentication, .processCanceledRegistration, .processCanceledLogin, .processCanceledAuthenticatorRegistration, .processCanceledAuthenticatorDeregistration:
            return 8017
        case .authenticatorNotRegistered:
            return 8023
        case .notInProgressRegistration, .notInProgressAuthentication, .notInProgressOtpAuthentication, .notInProgressPinCreation:
            return 8034
        case .alreadyInProgressMobileAuth:
            return 8041
        case .actionNotAllowedCustomRegistrationSubmit, .actionNotAllowedCustomRegistrationCancel, .actionNotAllowedBrowserRegistrationCancel:
            return 8042
        }
    }

    func message() -> String {
        switch self {
        case .genericError:
            return "Something went wrong."
        case .doesNotExistUserProfile:
            return "The requested User profile does not exist."
        case .notAuthenticatedUser:
            return "There is currently no User Profile authenticated."
        case .notAuthenticatedImplicit:
            return "The requested action requires you to be authenticated implicitly."
        case .notFoundAuthenticator:
            return "The requested authenticator is not found."
        case .providedUrlIncorrect:
            return "Provided url is incorrect."
        case .enrollmentFailed:
            return "Enrollment failed. Please try again or contact maintainer."
        case .processCanceledLogin:
            return "Login cancelled."
        case .processCanceledAuthentication:
            return "Authentication cancelled."
        case .processCanceledAuthenticatorDeregistration:
            return "Authenticator deregistration cancelled."
        case .processCanceledRegistration:
            return "Registration cancelled."
        case .authenticatorNotRegistered:
            return "This authenticator is not registered."
        case .httpRequestErrorNoResponse:
            return "OneWelcome: HTTP Request failed. Response doesn't contain data."
        case .httpRequestErrorCode:
            return "OneWelcome: HTTP Request failed. Check Response for more info."
        case .httpRequestErrorInternal:
            return "OneWelcome: HTTP Request failed. Check iosCode and iosMessage for more info."
        case .processCanceledAuthenticatorRegistration:
            return "The authenticator-registration was cancelled."
        case .notInProgressRegistration:
            return "Registration is currently not in progress."
        case .notInProgressAuthentication:
            return "Authentication is currently not in progress."
        case .notInProgressOtpAuthentication:
            return "OTP Authentication is currently not in progress."
        case .notInProgressPinCreation:
            return "Pin Creation is currently not in progress"
        case .alreadyInProgressMobileAuth:
            return "Mobile Authentication is already in progress and can not be performed concurrently."
        case .actionNotAllowedCustomRegistrationSubmit:
            return "Submitting the Custom registration right now is not allowed. Registration is not in progress or pin creation has already started."
        case .actionNotAllowedCustomRegistrationCancel:
            return "Canceling the Custom registration right now is not allowed. Registration is not in progress or pin creation has already started."
        case .actionNotAllowedBrowserRegistrationCancel:
            return "Canceling the Browser registration right now is not allowed. Registration is not in progress or pin creation has already started."
        }
    }
}

class ErrorMapper {
    func mapError(_ error: Error) -> SdkError {
        Logger.log("Error domain: \(error.domain)")

        return SdkError(code: error.code, errorDescription: error.localizedDescription)
    }
}
