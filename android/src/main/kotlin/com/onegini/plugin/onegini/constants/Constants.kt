package com.onegini.plugin.onegini.constants

interface Constants {
    companion object {
        const val NEW_LINE = "\n"

        /**
         *  events
         */
        const val EVENT_OPEN_PIN = "eventOpenPin"
        const val EVENT_CLOSE_PIN = "eventClosePin"
        const val EVENT_OPEN_PIN_AUTH = "eventOpenPinAuth"
        const val EVENT_OPEN_PIN_CONFIRMATION = "eventOpenPinConfirmation"
        const val EVENT_NEXT_AUTHENTICATION_ATTEMPT = "eventNextAuthenticationAttempt"


        /**
         * MethodsName
         */
        const val METHOD_START_APP ="startApp"
        const val METHOD_GET_PLATFORM_VERSION ="getPlatformVersion"
        const val METHOD_GET_APPLICATION_DETAILS ="getApplicationDetails"
        const val METHOD_GET_CLIENT_RESOURCE ="getClientResource"
        const val METHOD_GET_IMPLICIT_USER_DETAILS ="getImplicitUserDetails"
        const val METHOD_REGISTRATION ="registration"
        const val METHOD_CANCEL_REGISTRATION = "cancelRegistration"
        const val METHOD_SEND_PIN ="sendPin"
        const val METHOD_SINGLE_SIGN_ON ="singleSignOn"
        const val METHOD_LOG_OUT ="logOut"
        const val METHOD_DEREGISTER_USER ="deregisterUser"
        const val METHOD_GET_IDENTITY_PROVIDERS ="getIdentityProviders"
        const val METHOD_REGISTRATION_WITH_IDENTITY_PROVIDER ="registrationWithIdentityProvider"
        const val METHOD_PIN_AUTHENTICATION = "pinAuthentication"
        const val METHOD_CANCEL_PIN_AUTH = "cancelPinAuth"
    }
}
