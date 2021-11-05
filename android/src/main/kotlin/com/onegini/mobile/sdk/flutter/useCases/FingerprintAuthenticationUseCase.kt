package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.flutter.OneginiSDK

class FingerprintAuthenticationUseCase(private var oneginiSDK: OneginiSDK) {

    fun acceptAuthenticationRequest() {
        oneginiSDK.getFingerprintAuthenticationRequestHandler().fingerprintCallback?.acceptAuthenticationRequest()
    }

    fun denyAuthenticationRequest() {
        oneginiSDK.getFingerprintAuthenticationRequestHandler().fingerprintCallback?.denyAuthenticationRequest()
    }

    fun fallbackToPin() {
        oneginiSDK.getFingerprintAuthenticationRequestHandler().fingerprintCallback?.fallbackToPin()
    }
}