import OneginiSDKiOS

enum OneWelcomeWrapperError: Int {
    // iOS and Android
    case genericError = 8000
    case userProfileDoesNotExist = 8001
    case noUserProfileIsAuthenticated = 8002
    case authenticatorNotFound = 8004
    case httpRequestError = 8011
    case errorCodeHttpRequest = 8013
    case registrationNotInProgress = 8034
    case unauthenticatedImplicitly = 8035
    case methodArgumentNotFound = 8036
    case authenticationNotInProgress = 8037
    case otpAuthenticationNotInProgress = 8039
    case browserRegistrationNotInProgress = 8040

    // iOS only
    case providedUrlIncorrect = 8014
    case loginCanceled = 8015
    case enrollmentFailed = 8016
    case authenticationCancelled = 8017
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
    case mobileAuthInProgress = 8041

    func message() -> String {
        switch self {
        case .genericError:
            return "Something went wrong."
        case .userProfileDoesNotExist:
            return "The requested User profile does not exist."
        case .noUserProfileIsAuthenticated:
            return "There is currently no User Profile authenticated."
        case .authenticatorNotFound:
            return "The requested authenticator is not found."
        case .providedUrlIncorrect:
            return "Provided url is incorrect."
        case .enrollmentFailed:
            return "Enrollment failed. Please try again or contact maintainer."
        case .loginCanceled:
            return "Login cancelled."
        case .authenticationCancelled:
            return "Authentication cancelled."
        case .authenticatorDeregistrationCancelled:
            return "Authenticator deregistration cancelled."
        case .registrationCancelled:
            return "Registration cancelled."
        case .cantHandleOTP:
            return "Can't handle otp authentication request."
        case .incorrectResourcesAccess:
            return "Incorrect access to resources."
        case .authenticatorNotRegistered:
            return "This authenticator is not registered."
        case .failedToParseData:
            return "Failed to parse data."
        case .responseIsNull:
            return "Response doesn't contain data."
        case .authenticatorIdIsNull:
            return "Authenticator ID is empty."
        case .emptyInputValue:
            return "Empty input value."
        case .errorCodeHttpRequest:
            return "OneWelcome: HTTP Request failed. Check Response for more info."
        case .httpRequestError:
            return "OneWelcome: HTTP Request failed. Check iosCode and iosMessage for more info."
        case .unsupportedPinAction:
            return "Unsupported pin action. Contact SDK maintainer."
        case .unsupportedCustomRegistrationAction:
            return "Unsupported custom registration action. Contact SDK maintainer."
        case .authenticatorRegistrationCancelled:
            return "The authenticator-registration was cancelled."
        case .unauthenticatedImplicitly:
            return "The requested action requires you to be authenticated implicitly."
        case .methodArgumentNotFound:
            return "The passed argument from Flutter could not be found."
        case .registrationNotInProgress:
            return "Registration is currently not in progress."
        case .authenticationNotInProgress:
            return "Authentication is currently not in progress."
        case .otpAuthenticationNotInProgress:
            return "OTP Authentication is currently not in progress."
        case .mobileAuthInProgress:
            return "Mobile Authentication is already in progress and can not be performed concurrently."
        case .browserRegistrationNotInProgress:
            return "Browser registration is currently not in progress."
        }
    }
}

class ErrorMapper {
    func mapError(_ error: Error) -> SdkError {
        Logger.log("Error domain: \(error.domain)")

        return SdkError(code: error.code, errorDescription: error.localizedDescription)
    }
}
