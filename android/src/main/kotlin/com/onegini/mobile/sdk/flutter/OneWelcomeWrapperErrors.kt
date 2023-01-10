package com.onegini.mobile.sdk.flutter

enum class OneWelcomeWrapperErrors(val code: Int, val message: String) {
    GENERIC(8000, "Something went wrong"),
    USER_PROFILE_IS_NULL(8001, "User profile is null"),
    AUTHENTICATED_USER_PROFILE_IS_NULL(8002, "Authenticated user profile is null"),
    AUTHENTICATOR_NOT_FOUND(8004, "The requested authenticator is not found"),
    HTTP_REQUEST_ERROR(8011, "OneWelcome: HTTP Request failed internally."),
    ERROR_CODE_HTTP_REQUEST(8013, "OneWelcome: HTTP Request failed. Check Response for more info."),

    // Errors that only occur on Android
    AUTHENTICATOR_IS_NULL(8003, "Authenticator is null"),
    IDENTITY_PROVIDER_NOT_FOUND(8005, "The requested identity provider is not found"),
    QR_CODE_NOT_HAVE_DATA(8006, "QR-code does not have data"),
    METHOD_TO_CALL_NOT_FOUND(8007, "Method to call not found"),
    URL_CANT_BE_NULL(8008, "Url can not be null"),
    URL_IS_NOT_WEB_PATH(8009, "Incorrect url format"),
    PREFERRED_AUTHENTICATOR_ERROR(8010, "Something went wrong when setting the preferred authenticator"),
    ONEWELCOME_SDK_NOT_INITIALIZED(8012, "OneWelcomeSDK not initialized"),
    CONFIG_ERROR(8029, "Something went wrong while setting the configuration"),
    SECURITY_CONTROLLER_ERROR(8030, "Something went wrong while setting the security controller"),
}
