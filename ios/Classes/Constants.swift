import Foundation

struct Constants {
    struct Routes {
        
        // onegini methods
        static let startApp: String = "startApp"

        static let customTwoStepRegistrationReturnSuccess: String = "customTwoStepRegistrationReturnSuccess"
        static let customTwoStepRegistrationReturnError: String = "customTwoStepRegistrationReturnError"
        
        // registration
        static let registerUser: String = "registerUser"
        static let cancelRegistration: String = "cancelRegistration"
        static let getIdentityProviders: String = "getIdentityProviders"
        static let denyPinRegistrationRequest: String = "denyPinRegistrationRequest"
        static let acceptPinRegistrationRequest: String = "acceptPinRegistrationRequest"
        static let deregisterUser: String = "deregisterUser"
        static let handleRegisteredUserUrl: String = "handleRegisteredUserUrl"
        
        //authentication
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
        static let unauthenticatedRequest: String = "getUnauthenticatedResource";
        
        static let eventHandleRegisteredUrl: String = "eventHandleRegisteredUrl"

        //Other
        static let getAppToWebSingleSignOn: String = "getAppToWebSingleSignOn";
        static let changePin: String = "changePin";
        static let userProfiles: String = "userProfiles";
    }
    
    struct Parameters {
        static let connectionTimeout: String = "connectionTimeout"
        static let twoStepCustomIdentityProviderIds: String = "twoStepCustomIdentityProviderIds"
        static let identityProviderId: String = "identityProviderId"
        static let scopes: String = "scopes"
        static let authenticatorId: String = "authenticatorId"
        static let profileId: String = "profileId"
    }
}
