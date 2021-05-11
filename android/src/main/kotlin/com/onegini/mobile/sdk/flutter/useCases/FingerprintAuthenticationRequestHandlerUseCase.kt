package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiFingerprintCallback

class FingerprintAuthenticationRequestHandlerUseCase(private val oneginiFingerprintCallback: OneginiFingerprintCallback?) {
    fun acceptAuthenticationRequest() {
        oneginiFingerprintCallback?.acceptAuthenticationRequest()
    }

    fun denyAuthenticationRequest() {
        oneginiFingerprintCallback?.denyAuthenticationRequest()
    }

    fun fallbackToPin() {
        oneginiFingerprintCallback?.fallbackToPin()
    }
}