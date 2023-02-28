import Foundation

enum Constants {
    enum Routes {
        
        // onegini methods
        static let startApp = "startApp"

        // Submit CustomRegistration Actions
        static let submitCustomRegistrationAction = "submitCustomRegistrationAction"
        static let cancelCustomRegistrationAction = "cancelCustomRegistrationAction"
        
        // registration
        static let registerUser = "registerUser"
        static let cancelBrowserRegistration = "cancelBrowserRegistration"
        static let getIdentityProviders = "getIdentityProviders"
        static let denyPinRegistrationRequest = "denyPinRegistrationRequest"
        static let acceptPinRegistrationRequest = "acceptPinRegistrationRequest"
        static let deregisterUser = "deregisterUser"
        static let handleRegisteredUserUrl = "handleRegisteredUserUrl"
        static let getRedirectUrl = "getRedirectUrl"
        
        //authentication
        static let authenticateUser = "authenticateUser"
        static let authenticateDevice = "authenticateDevice"
        static let authenticateUserImplicitly = "authenticateUserImplicitly"
        static let getAccessToken = "getAccessToken"
        static let getAllNotRegisteredAuthenticators = "getAllNotRegisteredAuthenticators"
        static let getRegisteredAuthenticators = "getRegisteredAuthenticators"
        static let getAllAuthenticators = "getAllAuthenticators"
        static let registerAuthenticator = "registerAuthenticator"
        static let denyPinAuthenticationRequest = "denyPinAuthenticationRequest"
        static let acceptPinAuthenticationRequest = "acceptPinAuthenticationRequest"
        static let logout = "logout";
        static let validatePinWithPolicy = "validatePinWithPolicy"
        static let setPreferredAuthenticator = "setPreferredAuthenticator"
        static let deregisterAuthenticator = "deregisterAuthenticator"

        //fingerprint
        static let acceptFingerprintAuthenticationRequest = "acceptFingerprintAuthenticationRequest"
        static let denyFingerprintAuthenticationRequest = "denyFingerprintAuthenticationRequest"
        static let fingerprintFallbackToPin = "fingerprintFallbackToPin"

        //otp
        static let handleMobileAuthWithOtp = "handleMobileAuthWithOtp"
        static let acceptOtpAuthenticationRequest = "acceptOtpAuthenticationRequest"
        static let denyOtpAuthenticationRequest = "denyOtpAuthenticationRequest"

        //resources
        static let getResourceAnonymous = "getResourceAnonymous"
        static let getResource = "getResource"
        static let getImplicitResource = "getImplicitResource"
        static let unauthenticatedRequest = "getUnauthenticatedResource"
        
        static let eventHandleRegisteredUrl = "eventHandleRegisteredUrl"

        //Other
        static let getAppToWebSingleSignOn = "getAppToWebSingleSignOn"
        static let changePin = "changePin"
        static let getUserProfiles = "getUserProfiles"
        static let getAuthenticatedUserProfile = "getAuthenticatedUserProfile"
    }
    
    enum Keys {
        static let userProfile = "userProfile"
        static let profileId = "profileId"
    }
}
