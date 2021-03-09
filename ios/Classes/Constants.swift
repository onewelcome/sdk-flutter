import Foundation

struct Constants {
    struct Routes {
        static let startApp: String = "startApp"
        static let cancelRegistration: String = "cancelRegistration"
        static let sendPin: String = "sendPin"
        static let pinAuthentication = "pinAuthentication"
        static let registrationWithIdentityProvider = "registrationWithIdentityProvider"
        static let registration = "registration"
        static let deregisterUser = "deregisterUser"
        static let getIdentityProviders = "getIdentityProviders"
        static let getImplicitUserDetails = "getImplicitUserDetails"
        static let getApplicationDetails = "getApplicationDetails"
        static let getClientResource = "getClientResource"
        static let logOut = "logOut"
        static let getRegisteredAuthenticators = "getRegisteredAuthenticators"
        static let authenticateWithRegisteredAuthentication = "authenticateWithRegisteredAuthentication"
        static let changePin = "changePin"
        static let singleSignOn = "singleSignOn"
        static let cancelPinAuth = "cancelPinAuth"
        static let registerFingerprintAuthenticator = "registerFingerprintAuthenticator"
        static let fingerprintActivationSensor = "fingerprintActivationSensor"
        static let isUserNotRegisteredFingerprint = "isUserNotRegisteredFingerprint"
    }
}
