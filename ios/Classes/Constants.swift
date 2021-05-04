import Foundation

struct Constants {
    // TODO: change it to enum
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
        static let handleRegisteredUserUrl: String = "handleRegisteredUserUrl"
        
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
        
        static let eventHandleRegisteredUrl: String = "eventHandleRegisteredUrl"

        // other
        static let getAppToWebSingleSignOn: String = "getAppToWebSingleSignOn";
        static let changePin: String = "changePin";
        static let userProfiles: String = "userProfiles";
        
        // browser
        static let openUrl: String = "openUrl";
    }
    
    enum Events: String {
        
        // pin
        case eventOpenCreatePin = "eventOpenPin"
        case eventCloseCreatePin = "eventClosePin"
        case eventOpenAutorizePin = "eventOpenPinAuth"
        case eventCloseAutorizePin = "eventClosePinAuth"
        
        // browser
        case eventHandleRegisteredUrl = "eventHandleRegisteredUrl"
        
        // fingerprint
        case eventOpenFingerprintAuth = "eventOpenFingerprintAuth"
        case eventReceivedFingerprintAuth = "eventReceivedFingerprintAuth"
        case eventShowScanningFingerprintAuth = "eventShowScanningFingerprintAuth"
        case eventCloseFingerprintAuth = "eventCloseFingerprintAuth"

        // otp
        case eventOpenAuthOTP = "eventOpenAuthOtp"
        case eventCancelAuthOTP = "eventCancelAuthOtp"
        case eventCloseAuthOTP = "eventCloseAuthOtp"

        // custom
        case openCustomTwoStepRegistrationScreen = "openCustomTwoStepRegistrationScreen"
        
        case eventNextAuthenticationAttempt = "eventNextAuthenticationAttempt"

        // error
        case eventError = "eventError"
    }
    
    struct Parameters {
        static let identityProviderId: String = "identityProviderId"
        static let scopes: String = "scopes"
        
        static let url: String = "url"
        static let pin: String = "pin"
        static let prompt: String = "prompt"
        
        static let profileId: String = "profileId"
        static let authenticatorId: String = "authenticatorId"
        static let registeredAuthenticatorId: String = "registeredAuthenticatorId"
        
        static let userProfile: String = "userProfile"
        static let customInfo: String = "customInfo"
        static let status: String = "status"
        static let data: String = "data"
        
        static let type: String = "type"
        
        static let eventName: String = "eventName"
        static let eventValue: String = "eventValue"

    }
}
