package com.onegini.mobile.sdk.flutter.constants

interface Constants {
    companion object {
        /**
         *  events
         */
        const val EVENT_ERROR = "eventError"

        const val EVENT_OPEN_PIN = "eventOpenPin"
        const val EVENT_CLOSE_PIN = "eventClosePin"
        const val EVENT_OPEN_PIN_AUTH = "eventOpenPinAuth"
        const val EVENT_CLOSE_PIN_AUTH = "eventClosePinAuth"
        const val EVENT_NEXT_AUTHENTICATION_ATTEMPT = "eventNextAuthenticationAttempt"

        const val EVENT_OPEN_FINGERPRINT_AUTH = "eventOpenFingerprintAuth"
        const val EVENT_RECEIVED_FINGERPRINT_AUTH = "eventReceivedFingerprintAuth"
        const val EVENT_SHOW_SCANNING_FINGERPRINT_AUTH = "eventShowScanningFingerprintAuth"
        const val EVENT_CLOSE_FINGERPRINT_AUTH = "eventCloseFingerprintAuth"

        const val EVENT_OPEN_AUTH_OTP = "eventOpenAuthOtp"
        const val EVENT_CLOSE_AUTH_OTP = "eventCloseAuthOtp"

        const val EVENT_INIT_CUSTOM_REGISTRATION = "eventInitCustomRegistration"
        const val EVENT_FINISH_CUSTOM_REGISTRATION = "eventFinishCustomRegistration"

        const val EVENT_HANDLE_REGISTERED_URL = "eventHandleRegisteredUrl"

        /**
         * MethodsName
         */
        const val METHOD_START_APP = "startApp"

        const val METHOD_SUBMIT_CUSTOM_REGISTRATION_SUCCESS_ACTION = "submitCustomRegistrationSuccessAction"
        const val METHOD_SUBMIT_CUSTOM_REGISTRATION_ERROR_ACTION = "submitCustomRegistrationErrorAction"

        const val METHOD_GET_APP_TO_WEB_SINGLE_SIGN_ON = "getAppToWebSingleSignOn"
        const val METHOD_CHANGE_PIN = "changePin"
        const val METHOD_GET_USER_PROFILES = "userProfiles"
        const val METHOD_GET_REDIRECT_URL = "getRedirectUrl"

        // Resources
        const val METHOD_AUTHENTICATE_DEVICE = "authenticateDevice"
        const val METHOD_AUTHENTICATE_USER_IMPLICITLY = "authenticateUserImplicitly"
        const val METHOD_GET_RESOURCE_ANONYMOUS = "getResourceAnonymous"
        const val METHOD_GET_RESOURCE = "getResource"
        const val METHOD_GET_IMPLICIT_RESOURCE = "getImplicitResource"
        const val METHOD_GET_UNAUTHENTICATED_RESOURCE = "getUnauthenticatedResource"

        //Registration
        const val METHOD_REGISTER_USER = "registerUser"
        const val METHOD_HANDLE_REGISTERED_URL = "handleRegisteredUserUrl"
        const val METHOD_CANCEL_BROWSER_REGISTRATION = "cancelBrowserRegistration"
        const val METHOD_DENY_PIN_REGISTRATION_REQUEST = "denyPinRegistrationRequest"
        const val METHOD_ACCEPT_PIN_REGISTRATION_REQUEST = "acceptPinRegistrationRequest"
        const val METHOD_GET_IDENTITY_PROVIDERS = "getIdentityProviders"
        const val METHOD_DEREGISTER_USER = "deregisterUser"

        // Authentication 
        const val METHOD_ACCEPT_PIN_AUTHENTICATION_REQUEST = "acceptPinAuthenticationRequest"
        const val METHOD_DENY_PIN_AUTHENTICATION_REQUEST = "denyPinAuthenticationRequest"
        const val METHOD_GET_REGISTERED_AUTHENTICATORS = "getRegisteredAuthenticators"
        const val METHOD_GET_ALL_NOT_REGISTERED_AUTHENTICATORS = "getAllNotRegisteredAuthenticators"
        const val METHOD_GET_ALL_AUTHENTICATORS = "getAllAuthenticators"
        const val METHOD_SET_PREFERRED_AUTHENTICATOR = "setPreferredAuthenticator"
        const val METHOD_REGISTER_AUTHENTICATOR = "registerAuthenticator"
        const val METHOD_DEREGISTER_AUTHENTICATOR = "deregisterAuthenticator"
        const val METHOD_AUTHENTICATE_USER = "authenticateUser"
        const val METHOD_IS_AUTHENTICATOR_REGISTERED = "isAuthenticatorRegistered"
        const val METHOD_LOGOUT = "logout"

        // Fingerprint
        const val METHOD_ACCEPT_FINGERPRINT_AUTHENTICATION_REQUEST = "acceptFingerprintAuthenticationRequest"
        const val METHOD_DENY_FINGERPRINT_AUTHENTICATION_REQUEST = "denyFingerprintAuthenticationRequest"
        const val METHOD_FINGERPRINT_FALL_BACK_TO_PIN = "fingerprintFallbackToPin"

        // Otp
        const val METHOD_HANDLE_MOBILE_AUTH_WITH_OTP = "handleMobileAuthWithOtp"
        const val METHOD_ACCEPT_OTP_AUTHENTICATION_REQUEST = "acceptOtpAuthenticationRequest"
        const val METHOD_DENY_OTP_AUTHENTICATION_REQUEST = "denyOtpAuthenticationRequest"

        const val METHOD_VALIDATE_PIN_WITH_POLICY = "validatePinWithPolicy"
        const val METHOD_GET_ACCESS_TOKEN = "getAccessToken"
        const val METHOD_GET_AUTHENTICATED_USER_PROFILE = "getAuthenticatedUserProfile"
    }
}
