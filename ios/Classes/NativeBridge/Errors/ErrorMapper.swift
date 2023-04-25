// swiftlint:disable cyclomatic_complexity
import OneginiSDKiOS

enum OneWelcomeWrapperError {
    case genericError
    case notAuthenticatedUser
    case notAuthenticatedImplicit
    case notFoundUserProfile
    case notFoundAuthenticator
    case notFoundIdentityProvider
    case httpRequestErrorInternal
    case httpRequestErrorCode
    case httpRequestErrorNoResponse // ios only
    case providedUrlIncorrect // ios only
    case notInProgressAuthentication
    case notInProgressOtpAuthentication
    case notInProgressPinCreation
    case alreadyInProgressMobileAuth // ios only
    case actionNotAllowedCustomRegistrationCancel
    case actionNotAllowedCustomRegistrationSubmit
    case actionNotAllowedBrowserRegistrationCancel
    case biometricAuthenticationNotAvailable

    func code() -> Int {
        switch self {
        case .genericError:
            return 8000
        case .notAuthenticatedUser, .notAuthenticatedImplicit:
            return 8002
        case .notFoundUserProfile, .notFoundAuthenticator, .notFoundIdentityProvider:
            return 8004
        case .httpRequestErrorInternal, .httpRequestErrorCode, .httpRequestErrorNoResponse:
            return 8011
        case .providedUrlIncorrect:
            return 8014
        case .notInProgressAuthentication, .notInProgressOtpAuthentication, .notInProgressPinCreation:
            return 8034
        case .alreadyInProgressMobileAuth:
            return 8041
        case .actionNotAllowedCustomRegistrationSubmit, .actionNotAllowedCustomRegistrationCancel, .actionNotAllowedBrowserRegistrationCancel:
            return 8042
        case .biometricAuthenticationNotAvailable:
            return 8043
        }
    }

    func message() -> String {
        switch self {
        case .genericError:
            return "Something went wrong."
        case .notFoundUserProfile:
            return "The requested User profile does not exist."
        case .notAuthenticatedUser:
            return "There is currently no User Profile authenticated."
        case .notAuthenticatedImplicit:
            return "The requested action requires you to be authenticated implicitly."
        case .notFoundAuthenticator:
            return "The requested authenticator is not found."
        case .notFoundIdentityProvider:
            return "The requested identity provider is not found"
        case .providedUrlIncorrect:
            return "Provided url is incorrect."
        case .httpRequestErrorNoResponse:
            return "OneWelcome: HTTP Request failed. Response doesn't contain data."
        case .httpRequestErrorCode:
            return "OneWelcome: HTTP Request failed. Check Response for more info."
        case .httpRequestErrorInternal:
            return "OneWelcome: HTTP Request failed. Check iosCode and iosMessage for more info."
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
        case .biometricAuthenticationNotAvailable:
            return "Biometric authentication is not supported on this device."
        }
    }
}

class ErrorMapper {
    func mapError(_ error: Error) -> SdkError {
        Logger.log("Error domain: \(error.domain)")

        return SdkError(code: error.code, errorDescription: error.localizedDescription)
    }
}
