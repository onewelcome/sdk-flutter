package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.flutter.OneginiSDK

class FingerprintFallbackToPinUseCase(private val oneginiSDK: OneginiSDK) {
    operator fun invoke() {
        oneginiSDK.getFingerprintAuthenticationRequestHandler().fingerprintCallback?.fallbackToPin()
    }
}