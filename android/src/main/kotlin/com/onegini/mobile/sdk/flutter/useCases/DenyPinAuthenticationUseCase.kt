package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.flutter.OneginiSDK

class DenyPinAuthenticationUseCase(private val oneginiSDK: OneginiSDK) {
    operator fun invoke() {
        oneginiSDK.getPinAuthenticationRequestHandler()?.oneginiPinCallback?.denyAuthenticationRequest()
    }
}