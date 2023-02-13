package com.onegini.mobile.sdk.flutter

enum class OneWelcomeWrapperErrors(val code: Int, val message: String) {
    GENERIC_ERROR(8000, "Something went wrong"),
    USER_PROFILE_IS_NULL(8001, "User profile is null"),
    AUTHENTICATED_USER_PROFILE_IS_NULL(8002, "Authenticated user profile is null"),
    AUTHENTICATOR_NOT_FOUND(8004, "The requested authenticator is not found"),
    HTTP_REQUEST_ERROR(8011, "OneWelcome: HTTP Request failed internally."),
    ERROR_CODE_HTTP_REQUEST(8013, "OneWelcome: HTTP Request returned an error code. Check Response for more info."),
    UNAUTHENTICATED_IMPLICITLY(8035, "The requested action requires you to be authenticated implicitly"),

    // Errors that only occur on Android
    AUTHENTICATOR_IS_NULL(8003, "Authenticator is null"),
    IDENTITY_PROVIDER_NOT_FOUND(8005, "The requested identity provider is not found"),
    QR_CODE_HAS_NO_DATA(8006, "QR-code does not have data"),
    METHOD_TO_CALL_NOT_FOUND(8007, "Method to call not found"),
    URL_CANT_BE_NULL(8008, "Url can not be null"),
    MALFORMED_URL(8009, "Incorrect url format"),
    PREFERRED_AUTHENTICATOR_ERROR(8010, "Something went wrong when setting the preferred authenticator"),
    ONEWELCOME_SDK_NOT_INITIALIZED(8012, "OneWelcomeSDK is not initialized"),
    CONFIG_ERROR(8032, "Something went wrong while setting the configuration"),
    SECURITY_CONTROLLER_NOT_FOUND(8033, "Security controller class not found"),
    REGISTRATION_NOT_IN_PROGRESS(8034, "No registration in progress for the given Identity Provider"),
}
