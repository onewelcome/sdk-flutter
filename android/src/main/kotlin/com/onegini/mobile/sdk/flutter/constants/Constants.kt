package com.onegini.mobile.sdk.flutter.constants

interface Constants {
    companion object {
        /**
         *  events
         */
        const val EVENT_OPEN_PIN = "eventOpenPin"
        const val EVENT_CLOSE_PIN = "eventClosePin"
        const val EVENT_OPEN_PIN_AUTH = "eventOpenPinAuth"
        const val EVENT_NEXT_AUTHENTICATION_ATTEMPT = "eventNextAuthenticationAttempt"

        const val EVENT_OPEN_FINGERPRINT_AUTH = "eventOpenFingerprintAuth"
        const val EVENT_RECEIVED_FINGERPRINT_AUTH = "eventReceivedFingerprintAuth"
        const val EVENT_SHOW_SCANNING_FINGERPRINT_AUTH = "eventShowScanningFingerprintAuth"
        const val EVENT_CLOSE_FINGERPRINT_AUTH = "eventCloseFingerprintAuth"

        const val EVENT_OPEN_AUTH_OTP = "eventOpenAuthOtp"
        const val EVENT_CLOSE_AUTH_OTP = "eventCloseAuthOtp"


        /**
         * MethodsName
         */
        const val METHOD_START_APP ="startApp"
        const val METHOD_GET_RESOURCE_ANONYMOUS ="getResourceAnonymous"
        const val METHOD_GET_RESOURCE ="getResource"
        const val METHOD_GET_IMPLICIT_RESOURCE ="getImplicitResource"
        const val METHOD_REGISTRATION ="registration"
        const val METHOD_CANCEL_REGISTRATION = "cancelRegistration"
        const val METHOD_SEND_PIN ="sendPin"
        const val METHOD_SINGLE_SIGN_ON ="singleSignOn"
        const val METHOD_LOG_OUT ="logOut"
        const val METHOD_DEREGISTER_USER ="deregisterUser"
        const val METHOD_GET_IDENTITY_PROVIDERS ="getIdentityProviders"
        const val METHOD_GET_REGISTERED_AUTHENTICATORS = "getRegisteredAuthenticators"
        const val METHOD_AUTHENTICATE_WITH_REGISTERED_AUTHENTICATION ="authenticateWithRegisteredAuthentication"
        const val METHOD_REGISTRATION_WITH_IDENTITY_PROVIDER ="registrationWithIdentityProvider"
        const val METHOD_PIN_AUTHENTICATION = "pinAuthentication"
        const val METHOD_CANCEL_PIN_AUTH = "cancelPinAuth"
        const val METHOD_FINGERPRINT_ACTIVATION_SENSOR = "fingerprintActivationSensor"
        const val METHOD_CHANGE_PIN = "changePin"
        const val METHOD_OTP_QR_CODE_RESPONSE = "otpQrCodeResponse"
        const val METHOD_ACCEPT_OTP_AUTH = "acceptOTPAuth"
        const val METHOD_DENY_OTP_AUTH = "denyOTPAuth"
        const val METHOD_GET_ALL_NOT_REGISTERED_AUTHENTICATORS = "getAllNotRegisteredAuthenticators"
        const val METHOD_REGISTER_AUTHENTICATOR = "registerAuthenticator"
    }
}
