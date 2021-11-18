package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.flutter.OneginiSDK

class DenyPinRegistrationUseCase(private val oneginiSDK: OneginiSDK) {
    operator fun invoke() {
        oneginiSDK.getPinRequestHandler()?.getCallback()?.denyAuthenticationRequest()
    }
}