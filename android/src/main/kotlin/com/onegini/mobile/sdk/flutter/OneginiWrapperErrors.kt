package com.onegini.mobile.sdk.flutter

enum class OneginiWrapperErrors(val code: String, val message: String) {
    USER_PROFILE_IS_NULL("8001", "user profile is null"),
    AUTHENTICATED_USER_PROFILE_IS_NULL("8002", "authenticated user profile is null"),
    AUTHENTICATOR_IS_NULL("8003", "authenticator is null"),
    AUTHENTICATOR_NOT_FOUND("8004", "authenticator not found"),
    IDENTITY_PROVIDER_NOT_FOUND("8005", "identity providers not found"),
    QR_CODE_NOT_HAVE_DATA("8006", "qr code not have data"),
    METHOD_TO_CALL_NOT_FOUND("8007", "method to call not found"),
    URL_CANT_BE_NULL("8008", "url can`t be null"),
    URL_IS_NOT_WEB_PATH("8009", "incorrect url format"),
    PREFERRED_AUTHENTICATOR_ERROR("8010", "something went wrong"),
    HTTP_REQUEST_ERROR("8011","")
}
