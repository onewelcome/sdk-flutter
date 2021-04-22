package com.onegini.mobile.sdk.flutter

import com.onegini.mobile.sdk.flutter.models.Error

class OneginiWrapperErrors {
    val userProfileIsNull = Error("8001", "user profile is null")
    val authenticatedUserProfileIsNull = Error("8002", "authenticated user profile is null")
    val authenticatorIsNull = Error("8003", "authenticator is null")
    val registeredAuthenticatorsIsNull = Error("8004", "registered authenticators is null")
    val identityProvidersIsNull = Error("8005", "identity providers is null")
    val qrCodeNotHaveData = Error("8006", "qr code not have data")
    val methodToCallNotFound = Error("8007", "method to call not found")
    val urlCantBeNull = Error("8008", "url can`t be null")
    val urlIsNotWebPath = Error("8009", "incorrect url format")
    val preferredAuthenticator = Error("8010", "something went wrong")
}
