package com.onegini.mobile.sdk.flutter

enum class OneWelcomeWrapperErrors(val code: Int, val message: String) {
  GENERIC_ERROR(8000, "Something went wrong"),
  NOT_AUTHENTICATED_USER(8040, "There is currently no User Profile authenticated"),
  NOT_AUTHENTICATED_IMPLICIT(8041, "The requested action requires you to be authenticated implicitly"),
  NOT_FOUND_USER_PROFILE(8042, "The requested User profile is not found"),
  NOT_FOUND_AUTHENTICATOR(8043, "The requested authenticator is not found"),
  NOT_FOUND_IDENTITY_PROVIDER(8044, "The requested identity provider is not found"),
  NOT_FOUND_SECURITY_CONTROLLER(8045, "The requested Security controller class is not found"), // Android only
  HTTP_REQUEST_ERROR_INTERNAL(8046, "OneWelcome: HTTP Request failed internally"),
  HTTP_REQUEST_ERROR_CODE(8047, "OneWelcome: HTTP Request returned an http error code. Check Response for more info"),
  ONEWELCOME_SDK_NOT_INITIALIZED(8049, "OneWelcomeSDK is not initialized"), // Android only
  NOT_IN_PROGRESS_CUSTOM_REGISTRATION(8051, "Custom Registration is currently not in progress"),
  NOT_IN_PROGRESS_AUTHENTICATION(8052, "Authentication is currently not in progress"),
  NOT_IN_PROGRESS_OTP_AUTHENTICATION(8053, "OTP Authentication is currently not in progress"),
  NOT_IN_PROGRESS_PIN_CREATION(8054, "Pin Creation is currently not in progress"),
  NOT_IN_PROGRESS_FINGERPRINT_AUTHENTICATION(8055, "Fingerprint Authentication is currently not in progress"),
  ACTION_NOT_ALLOWED_CUSTOM_REGISTRATION_CANCEL(
    8057,
    "Canceling the Custom registration right now is not allowed." +
        " Registration is not in progress or pin creation has already started"
  ),
  ACTION_NOT_ALLOWED_BROWSER_REGISTRATION_CANCEL(
    8058,
    "Canceling the Browser registration right now is not allowed." +
        " Registration is not in progress or pin creation has already started"
  ),
  CONFIG_ERROR(8059, "Something went wrong while setting the configuration"), // Android only
  BIOMETRIC_AUTHENTICATION_NOT_AVAILABLE(8060, "Biometric authentication is not supported on this device"),
  UNEXPECTED_ERROR_TYPE(8999, "An unexpected error type was returned"), // Android only
}
