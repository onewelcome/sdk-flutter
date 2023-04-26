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
    case invalidUrl
    case notInProgressAuthentication
    case notInProgressOtpAuthentication
    case notInProgressPinCreation
    case notInProgressCustomRegistration
    case alreadyInProgressMobileAuth // ios only
    case actionNotAllowedCustomRegistrationCancel
    case actionNotAllowedBrowserRegistrationCancel
    case biometricAuthenticationNotAvailable

    func code() -> Int {
        switch self {
        case .genericError:
            return 8000
        case .notAuthenticatedUser:
            return 8040
        case .notAuthenticatedImplicit:
            return 8041
        case .notFoundUserProfile:
            return 8042
        case .notFoundAuthenticator:
            return 8043
        case .notFoundIdentityProvider:
            return 8044
        case .httpRequestErrorInternal:
            return 8046
        case .httpRequestErrorCode:
            return 8047
        case .httpRequestErrorNoResponse:
            return 8048
        case .invalidUrl:
            return 8050
        case .notInProgressCustomRegistration:
            return 8051
        case .notInProgressAuthentication:
            return 8052
        case .notInProgressOtpAuthentication:
            return 8053
        case .notInProgressPinCreation:
            return 8054
        case .alreadyInProgressMobileAuth:
            return 8056
        case .actionNotAllowedCustomRegistrationCancel:
            return 8057
        case .actionNotAllowedBrowserRegistrationCancel:
            return 8058
        case .biometricAuthenticationNotAvailable:
            return 8060
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
        case .invalidUrl:
            return "Provided url is incorrect."
        case .httpRequestErrorNoResponse:
            return "The resource Request failed. The HTTP response doesn't contain data."
        case .httpRequestErrorCode:
            return "The resource Request returned an http error code. Check Response for more info."
        case .httpRequestErrorInternal:
            return "The resource Request failed internally. Check iosCode and iosMessage for more info."
        case .notInProgressAuthentication:
            return "Authentication is currently not in progress."
        case .notInProgressOtpAuthentication:
            return "OTP Authentication is currently not in progress."
        case .notInProgressPinCreation:
            return "Pin Creation is currently not in progress"
        case .alreadyInProgressMobileAuth:
            return "Mobile Authentication is already in progress and can not be performed concurrently."
        case .notInProgressCustomRegistration:
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
