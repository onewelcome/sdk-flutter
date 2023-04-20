package com.onegini.mobile.sdk.flutter

enum class OneWelcomeWrapperErrors(val code: Int, val message: String) {
  GENERIC_ERROR(8000, "Something went wrong"),

  DOES_NOT_EXIST_USER_PROFILE(8001, "The requested User profile does not exist"),

  NOT_FOUND_AUTHENTICATOR(8004, "The requested authenticator is not found"),
  NOT_FOUND_IDENTITY_PROVIDER(8004, "The requested identity provider is not found"),
  NOT_FOUND_SECURITY_CONTROLLER(8004, "The requested Security controller class is not found"),

  HTTP_REQUEST_ERROR_INTERNAL(8011, "OneWelcome: HTTP Request failed internally"),
  HTTP_REQUEST_ERROR_CODE(8011, "OneWelcome: HTTP Request returned an error code. Check Response for more info"),

  NOT_IN_PROGRESS_REGISTRATION(8034, "Registration is currently not in progress"),
  NOT_IN_PROGRESS_CUSTOM_REGISTRATION(8034, "Custom Registration is currently not in progress"),
  NOT_IN_PROGRESS_AUTHENTICATION(8034, "Authentication is currently not in progress"),
  NOT_IN_PROGRESS_FINGERPRINT_AUTHENTICATION(8034, "Fingerprint Authentication is currently not in progress"),
  NOT_IN_PROGRESS_OTP_AUTHENTICATION(8034, "OTP Authentication is currently not in progress"),
  NOT_IN_PROGRESS_BROWSER_REGISTRATION(8034, "Browser Registration is currently not in progress"),
  NOT_IN_PROGRESS_PIN_CREATION(8034, "Pin Creation is currently not in progress"),


//  DOES_NOT_EXIST_USER_PROFILE(8001, "The requested User profile does not exist"),
  NO_USER_PROFILE_IS_AUTHENTICATED(8002, "There is currently no User Profile authenticated"),
//  NOT_FOUND_AUTHENTICATOR(8004, "The requested authenticator is not found"),
//HTTP_REQUEST_ERROR_INTERNAL(8011, "OneWelcome: HTTP Request failed internally"),
//HTTP_REQUEST_ERROR_CODE(8013, "OneWelcome: HTTP Request returned an error code. Check Response for more info"),

//  NOT_IN_PROGRESS_REGISTRATION(8034, "Registration is currently not in progress"),
//NOT_IN_PROGRESS_AUTHENTICATION(8037, "Authentication is currently not in progress"),
//NOT_IN_PROGRESS_FINGERPRINT_AUTHENTICATION(8038, "Fingerprint Authentication is currently not in progress"),
//NOT_IN_PROGRESS_OTP_AUTHENTICATION(8039, "OTP Authentication is currently not in progress"),
//NOT_IN_PROGRESS_BROWSER_REGISTRATION(8040, "Browser registration is currently not in progress"),
//NOT_IN_PROGRESS_PIN_CREATION(8042, "Pin creation is currently not in progress"),

  // Errors that only occur on Android
//  NOT_FOUND_IDENTITY_PROVIDER(8005, "The requested identity provider is not found"),
  ONEWELCOME_SDK_NOT_INITIALIZED(8012, "OneWelcomeSDK is not initialized"),
  CONFIG_ERROR(8032, "Something went wrong while setting the configuration"),
//  NOT_FOUND_SECURITY_CONTROLLER(8033, "Security controller class not found"),
  UNEXPECTED_ERROR_TYPE(8999, "An unexpected error type was returned"),
}
