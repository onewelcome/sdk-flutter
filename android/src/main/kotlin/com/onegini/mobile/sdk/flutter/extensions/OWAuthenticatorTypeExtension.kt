package com.onegini.mobile.sdk.flutter.extensions

import com.onegini.mobile.sdk.android.model.OneginiAuthenticator
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWAuthenticatorType

fun OWAuthenticatorType.toOneginiInt(): Int {
    return when (this) {
        OWAuthenticatorType.PIN -> OneginiAuthenticator.PIN
        OWAuthenticatorType.BIOMETRIC -> OneginiAuthenticator.FINGERPRINT
    }
}
