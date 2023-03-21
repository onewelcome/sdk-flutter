package com.onegini.mobile.sdk.flutter

enum class OneWelcomeWrapperErrors(val code: Int, val message: String) {
    GENERIC_ERROR(8000, "Something went wrong"),
    USER_PROFILE_DOES_NOT_EXIST(8001, "The requested User profile does not exist"),
    NO_USER_PROFILE_IS_AUTHENTICATED(8002, "There is currently no User Profile authenticated"),
    AUTHENTICATOR_NOT_FOUND(8004, "The requested authenticator is not found"),
    HTTP_REQUEST_ERROR(8011, "OneWelcome: HTTP Request failed internally"),
    ERROR_CODE_HTTP_REQUEST(8013, "OneWelcome: HTTP Request returned an error code. Check Response for more info"),

    REGISTRATION_NOT_IN_PROGRESS(8034, "Registration is currently not in progress"),
    USER_NOT_AUTHENTICATED_IMPLICITLY(8035, "The requested action requires you to be authenticated implicitly"),
    METHOD_ARGUMENT_NOT_FOUND(8036, "The passed argument from Flutter could not be found"),
    AUTHENTICATION_NOT_IN_PROGRESS(8037, "Authentication is currently not in progress"),
    FINGERPRINT_AUTHENTICATION_NOT_IN_PROGRESS(8038, "Fingerprint Authentication is currently not in progress"),

    // Errors that only occur on Android
    IDENTITY_PROVIDER_NOT_FOUND(8005, "The requested identity provider is not found"),
    QR_CODE_HAS_NO_DATA(8006, "QR-code does not have data"),
    METHOD_TO_CALL_NOT_FOUND(8007, "Method to call not found"),
    URL_CANT_BE_NULL(8008, "Url can not be null"),
    MALFORMED_URL(8009, "Incorrect url format"),
    PREFERRED_AUTHENTICATOR_ERROR(8010, "Something went wrong when setting the preferred authenticator"),
    ONEWELCOME_SDK_NOT_INITIALIZED(8012, "OneWelcomeSDK is not initialized"),
    CONFIG_ERROR(8032, "Something went wrong while setting the configuration"),
    SECURITY_CONTROLLER_NOT_FOUND(8033, "Security controller class not found"),
    UNEXPECTED_ERROR_TYPE(8999, "An unexpected error type was returned"),
}
