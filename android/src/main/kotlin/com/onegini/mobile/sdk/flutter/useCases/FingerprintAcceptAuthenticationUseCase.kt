package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.flutter.OneginiSDK

class FingerprintAcceptAuthenticationUseCase(private var oneginiSDK: OneginiSDK) {
    operator fun invoke() {
        oneginiSDK.getFingerprintAuthenticationRequestHandler()?.fingerprintCallback?.acceptAuthenticationRequest()
    }
}