package com.onegini.mobile.sdk.flutter.helpers

import com.onegini.mobile.sdk.flutter.models.Error

class ErrorHelper {
   val userProfileIsNull  = Error("8002","user profile is null")
   val fingerprintAuthenticatorIsNull = Error("8002","fingerprint authenticator is null")
   val registeredAuthenticatorsIsNull = Error("8003","registered authenticators is null")
   val identityProvidersIsNull = Error("8004","identity providers is null")
   val pinNotEquals = Error("8005","Password mismatch")
}