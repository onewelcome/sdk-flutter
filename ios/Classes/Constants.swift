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
        static let customTwoStepRegistrationReturnSuccess: String = "customTwoStepRegistrationReturnSuccess"
        static let customTwoStepRegistrationReturnError: String = "customTwoStepRegistrationReturnError"
        
        // authentication
        static let authenticateUser: String = "authenticateUser"
        static let getAllNotRegisteredAuthenticators: String = "getAllNotRegisteredAuthenticators"
        static let getRegisteredAuthenticators: String = "getRegisteredAuthenticators"
        static let registerAuthenticator: String = "registerAuthenticator";
        static let denyPinAuthenticationRequest: String = "denyPinAuthenticationRequest";
        static let acceptPinAuthenticationRequest: String = "acceptPinAuthenticationRequest";
        static let logout: String = "logout";
        static let validatePinWithPolicy: String = "validatePinWithPolicy"
        static let setPreferredAuthenticator: String = "setPreferredAuthenticator";
        static let deregisterAuthenticator: String = "deregisterAuthenticator"

        // fingerprint
        static let acceptFingerprintAuthenticationRequest: String = "acceptFingerprintAuthenticationRequest";
        static let denyFingerprintAuthenticationRequest: String = "denyFingerprintAuthenticationRequest";
        static let fingerprintFallbackToPin: String = "fingerprintFallbackToPin";

        // otp
        static let handleMobileAuthWithOtp: String = "handleMobileAuthWithOtp";
        static let acceptOtpAuthenticationRequest: String = "acceptOtpAuthenticationRequest";
        static let denyOtpAuthenticationRequest: String = "denyOtpAuthenticationRequest";

        // resources
        static let getResourceAnonymous: String = "getResourceAnonymous";
        static let getResource: String = "getResource";
        static let getImplicitResource: String = "getImplicitResource";
        static let unauthenticatedRequest: String = "getUnauthenticatedResource";

        // other
        static let getAppToWebSingleSignOn: String = "getAppToWebSingleSignOn";
        static let changePin: String = "changePin";
        static let userProfiles: String = "userProfiles";
        
        // browser
        static let openUrl: String = "openUrl";
    }
    
    struct Events {
        
        // pin
        static let eventOpenCreatePin: String = "eventOpenPin";
        static let eventCloseCreatePin: String = "eventClosePin";
        static let eventOpenAutorizePin: String = "eventOpenPinAuth";
        static let eventCloseAutorizePin: String = "eventClosePinAuth";
        
        // browser
        static let eventOpenUrl: String = "eventOpenUrl";
        
        // fingerprint
        static let eventOpenFingerprintAuth: String = "eventOpenFingerprintAuth";
        static let eventReceivedFingerprintAuth: String = "eventReceivedFingerprintAuth";
        static let eventShowScanningFingerprintAuth: String = "eventShowScanningFingerprintAuth";
        static let eventCloseFingerprintAuth: String = "eventCloseFingerprintAuth";

        // otp
        static let eventOpenAuthOTP: String = "eventOpenAuthOtp";
        static let eventCancelAuthOTP: String = "eventCancelAuthOtp";
        static let eventCloseAuthOTP: String = "eventCloseAuthOtp";

        // custom
        static let openCustomTwoStepRegistrationScreen: String = "openCustomTwoStepRegistrationScreen";
        
        
        static let eventNextAuthenticationAttempt: String = "eventNextAuthenticationAttempt";

        // error
        static let eventError: String = "eventError";
    }
    
    struct Parameters {
        static let identityProviderId: String = "identityProviderId";
        static let scopes: String = "scopes";
        
        static let pin: String = "pin";
        
        static let profileId: String = "profileId";
        
        static let eventName: String = "eventName";
        static let eventValue: String = "eventValue";

    }
}
