import UIKit
import OneginiSDKiOS
import OneginiCrypto

class AuthenticatorRegistrationErrorDomainMapping {
    let title = "Authenticator Registration error"

    func mapError(_ error: Error) -> SdkError {
        switch error.code {
        case ONGAuthenticatorRegistrationError.userNotAuthenticated.rawValue:
            let errorDescription = "A user must be authenticated in order to register an authenticator."
            return SdkError(title: title, errorDescription: errorDescription, recoverySuggestion: "Try authenticate user.")

        case ONGAuthenticatorRegistrationError.authenticatorInvalid.rawValue:
            let errorDescription = "The authenticator that you provided is invalid. It may not exist, please verify whether you have supplied the correct authenticator."
            return SdkError(title: title, errorDescription: errorDescription)

        case ONGAuthenticatorRegistrationError.customAuthenticatorFailure.rawValue:
            let errorDescription = "Custom authenticator registration has failed."
            return SdkError(title: title, errorDescription: errorDescription)

        default:
            return SdkError(errorDescription: "Something went wrong.")
        }
    }

    func mapErrorWithCustomInfo(_ customInfo: ONGCustomInfo) -> SdkError {
        if customInfo.status >= 4000 && customInfo.status < 5000 {
            let message = "Authenticator registration failed"
            return SdkError(title: title, errorDescription: message)
        } else {
            return SdkError(errorDescription: "Something went wrong.")
        }
    }
}

