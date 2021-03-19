import Foundation

struct Constants {
    struct Routes {
        
        // onegini methods
        static let startApp: String = "startApp"

        // registration
        static let registerUser: String = "registerUser"
        static let cancelRegistration: String = "cancelRegistration"
        static let getIdentityProviders: String = "getIdentityProviders"
        static let denyPinRegistrationRequest: String = "denyPinRegistrationRequest"
        static let acceptPinRegistrationRequest: String = "acceptPinRegistrationRequest"
        static let deregisterUser: String = "deregisterUser"
        
        //authentication
        static let authenticateUser: String = "authenticateUser";
        static let getAllNotRegisteredAuthenticators: String = "getAllNotRegisteredAuthenticators";
        static let getRegisteredAuthenticators: String = "getRegisteredAuthenticators";
        static let registerAuthenticator: String = "registerAuthenticator";
        static let denyPinAuthenticationRequest: String = "denyPinAuthenticationRequest";
        static let acceptPinAuthenticationRequest: String = "acceptPinAuthenticationRequest";
        static let logout: String = "logout";

        //fingerprint
        static let acceptFingerprintAuthenticationRequest: String = "acceptFingerprintAuthenticationRequest";
        static let denyFingerprintAuthenticationRequest: String = "denyFingerprintAuthenticationRequest";
        static let fingerprintFallbackToPin: String = "fingerprintFallbackToPin";

        //otp
        static let handleMobileAuthWithOtp: String = "handleMobileAuthWithOtp";
        static let acceptOtpAuthenticationRequest: String = "acceptOtpAuthenticationRequest";
        static let denyOtpAuthenticationRequest: String = "denyOtpAuthenticationRequest";

        //resources
        static let getResourceAnonymous: String = "getResourceAnonymous";
        static let getResource: String = "getResource";
        static let getImplicitResource: String = "getImplicitResource";

        //Other
        static let getAppToWebSingleSignOn: String = "getAppToWebSingleSignOn";
        static let changePin: String = "changePin";
        
        
        // old ones
//        static let cancelRegistration: String = "cancelRegistration"
//        static let sendPin: String = "sendPin"
//        static let pinAuthentication = "pinAuthentication"
//        static let registrationWithIdentityProvider = "registrationWithIdentityProvider"
//        static let registration = "registration"
//        static let deregisterUser = "deregisterUser"
//        static let getIdentityProviders = "getIdentityProviders"
//        static let logOut = "logOut"
//        static let getRegisteredAuthenticators = "getRegisteredAuthenticators"
//        static let authenticateWithRegisteredAuthentication = "authenticateWithRegisteredAuthentication"
//        static let changePin = "changePin"
//        static let singleSignOn = "singleSignOn"
//        static let cancelPinAuth = "cancelPinAuth"
//        static let registerFingerprintAuthenticator = "registerFingerprintAuthenticator"
//        static let fingerprintActivationSensor = "fingerprintActivationSensor"
//        static let isUserNotRegisteredFingerprint = "isUserNotRegisteredFingerprint"
//        static let getResourceAnonymous = "getResourceAnonymous"
//        static let getImplicitResource = "getImplicitResource"
//        static let getResource = "getResource"
    }
}
