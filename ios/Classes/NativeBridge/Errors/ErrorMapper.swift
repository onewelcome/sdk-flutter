// swiftlint:disable cyclomatic_complexity
import OneginiSDKiOS

enum OneWelcomeWrapperError {
    // iOS and Android
    case genericError
    case userProfileDoesNotExist
    case noUserProfileIsAuthenticated
    case authenticatorNotFound
    case httpRequestError
    case errorCodeHttpRequest
    case registrationNotInProgress
    case customRegistrationNotInProgress
    case unauthenticatedImplicitly
    case authenticationNotInProgress
    case otpAuthenticationNotInProgress
    case browserRegistrationNotInProgress

    // iOS only
    case providedUrlIncorrect
    case loginCanceled
    case enrollmentFailed
    case authenticationCancelled
    case registrationCancelled
    case authenticatorNotRegistered
    case authenticatorDeregistrationCancelled
    case responseIsNull
    case authenticatorRegistrationCancelled
    case mobileAuthInProgress

    func code() -> Int {
        switch self {
        case .genericError:
            return 8000
        case .userProfileDoesNotExist:
            return 8001
        case .noUserProfileIsAuthenticated:
            return 8002
        case .authenticatorNotFound:
            return 8004
        case .httpRequestError:
            return 8011
        case .errorCodeHttpRequest:
            return 8013
        case .registrationNotInProgress, .customRegistrationNotInProgress:
            return 8034
        case .unauthenticatedImplicitly:
            return 8035
        case .authenticationNotInProgress:
            return 8037
        case .otpAuthenticationNotInProgress:
            return 8039
        case .browserRegistrationNotInProgress:
            return 8040

        // iOS only
        case .providedUrlIncorrect:
            return 8014
        case .loginCanceled:
            return 8015
        case .enrollmentFailed:
            return 8016
        case .authenticationCancelled:
            return 8017
        case .registrationCancelled:
            return 8020
        case .authenticatorNotRegistered:
            return 8023
        case .authenticatorDeregistrationCancelled:
            return 8024
        case .responseIsNull:
            return 8026
        case .authenticatorRegistrationCancelled:
            return 8031
        case .mobileAuthInProgress:
            return 8041
        }
    }

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
        case .authenticatorNotRegistered:
            return "This authenticator is not registered."
        case .responseIsNull:
            return "Response doesn't contain data."
        case .errorCodeHttpRequest:
            return "OneWelcome: HTTP Request failed. Check Response for more info."
        case .httpRequestError:
            return "OneWelcome: HTTP Request failed. Check iosCode and iosMessage for more info."
        case .authenticatorRegistrationCancelled:
            return "The authenticator-registration was cancelled."
        case .unauthenticatedImplicitly:
            return "The requested action requires you to be authenticated implicitly."
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
