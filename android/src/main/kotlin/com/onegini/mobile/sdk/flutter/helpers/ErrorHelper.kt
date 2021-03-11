package com.onegini.mobile.sdk.flutter.helpers

import com.onegini.mobile.sdk.flutter.models.Error

class ErrorHelper {
   val userProfileIsNull  = Error("8001","user profile is null")
   val authenticatedUserProfileIsNull = Error("8002","authenticated user profile is null")
   val fingerprintAuthenticatorIsNull = Error("8003","fingerprint authenticator is null")
   val registeredAuthenticatorsIsNull = Error("8004","registered authenticators is null")
   val identityProvidersIsNull = Error("8005","identity providers is null")
   val clientIsNull = Error("8006","Onegini client is null")
   val pinNotEquals = Error("8007","Password mismatch")
}