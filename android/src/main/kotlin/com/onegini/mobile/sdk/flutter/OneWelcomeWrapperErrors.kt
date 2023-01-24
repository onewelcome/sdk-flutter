package com.onegini.mobile.sdk.flutter

enum class OneWelcomeWrapperErrors(val code: Int, val message: String) {
    GENERIC_ERROR(8000, "Something went wrong"),
    USER_PROFILE_IS_NULL_ERROR(8001, "User profile is null"),
    AUTHENTICATED_USER_PROFILE_IS_NULL_ERROR(8002, "Authenticated user profile is null"),
    AUTHENTICATOR_NOT_FOUND_ERROR(8004, "The requested authenticator is not found"),
    HTTP_REQUEST_ERROR(8011, "OneWelcome: HTTP Request failed internally."),
    ERROR_CODE_HTTP_REQUEST_ERROR(8013, "OneWelcome: HTTP Request failed. Check Response for more info."),

    // Errors that only occur on Android
    AUTHENTICATOR_IS_NULL_ERROR(8003, "Authenticator is null"),
    IDENTITY_PROVIDER_NOT_FOUND_ERROR(8005, "The requested identity provider is not found"),
    QR_CODE_HAS_NO_DATA_ERROR(8006, "QR-code does not have data"),
    METHOD_TO_CALL_NOT_FOUND_ERROR(8007, "Method to call not found"),
    URL_CANT_BE_NULL_ERROR(8008, "Url can not be null"),
    MALFORMED_URL_ERROR(8009, "Incorrect url format"),
    PREFERRED_AUTHENTICATOR_ERROR(8010, "Something went wrong when setting the preferred authenticator"),
    ONEWELCOME_SDK_NOT_INITIALIZED_ERROR(8012, "OneWelcomeSDK is not initialized"),
    CONFIG_ERROR(8029, "Something went wrong while setting the configuration"),
    SECURITY_CONTROLLER_NOT_FOUND_ERROR(8030, "Security controller class not found"),
}
