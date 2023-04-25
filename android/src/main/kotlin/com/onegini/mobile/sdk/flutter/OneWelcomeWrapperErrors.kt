package com.onegini.mobile.sdk.flutter

enum class OneWelcomeWrapperErrors(val code: Int, val message: String) {
  GENERIC_ERROR(8000, "Something went wrong"),
  NOT_AUTHENTICATED_USER(8002, "There is currently no User Profile authenticated"),
  NOT_AUTHENTICATED_IMPLICIT(8002, "The requested action requires you to be authenticated implicitly"),
  NOT_FOUND_USER_PROFILE(8004, "The requested User profile is not found"),
  NOT_FOUND_AUTHENTICATOR(8004, "The requested authenticator is not found"),
  NOT_FOUND_IDENTITY_PROVIDER(8004, "The requested identity provider is not found"), // Android only
  NOT_FOUND_SECURITY_CONTROLLER(8004, "The requested Security controller class is not found"), // Android only
  HTTP_REQUEST_ERROR_INTERNAL(8011, "OneWelcome: HTTP Request failed internally"),
  HTTP_REQUEST_ERROR_CODE(8011, "OneWelcome: HTTP Request returned an error code. Check Response for more info"),
  ONEWELCOME_SDK_NOT_INITIALIZED(8012, "OneWelcomeSDK is not initialized"), // Android only
  CONFIG_ERROR(8032, "Something went wrong while setting the configuration"), // Android only
  NOT_IN_PROGRESS_REGISTRATION(8034, "Registration is currently not in progress"),
  NOT_IN_PROGRESS_AUTHENTICATION(8034, "Authentication is currently not in progress"),
  NOT_IN_PROGRESS_FINGERPRINT_AUTHENTICATION(8034, "Fingerprint Authentication is currently not in progress"),
  NOT_IN_PROGRESS_OTP_AUTHENTICATION(8034, "OTP Authentication is currently not in progress"),
  NOT_IN_PROGRESS_PIN_CREATION(8034, "Pin Creation is currently not in progress"), // Android only
  ACTION_NOT_ALLOWED_CUSTOM_REGISTRATION_CANCEL(
    8042,
    "Canceling the Custom registration right now is not allowed." +
        " Registration is not in progress or pin creation has already started"
  ),
  ACTION_NOT_ALLOWED_CUSTOM_REGISTRATION_SUBMIT(
    8042,
    "Submitting the Custom registration right now is not allowed." +
        " Registration is not in progress or pin creation has already started"
  ),
  ACTION_NOT_ALLOWED_BROWSER_REGISTRATION_CANCEL(
    8042,
    "Canceling the Browser registration right now is not allowed." +
        " Registration is not in progress or pin creation has already started"
  ),
  BIOMETRIC_AUTHENTICATION_NOT_AVAILABLE(8043, "Biometric authentication is not supported on this device"),
  UNEXPECTED_ERROR_TYPE(8999, "An unexpected error type was returned"), // Android only
}
