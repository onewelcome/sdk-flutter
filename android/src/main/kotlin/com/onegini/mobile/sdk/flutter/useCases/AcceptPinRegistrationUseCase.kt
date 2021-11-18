package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.flutter.OneginiSDK
import io.flutter.plugin.common.MethodCall

class AcceptPinRegistrationUseCase(private val oneginiSDK: OneginiSDK) {
    operator fun invoke(call: MethodCall) {
        val pin: CharArray? = call.argument<String>("pin")?.toCharArray()
        oneginiSDK.getPinRequestHandler()?.getCallback()?.acceptAuthenticationRequest(pin)
    }
}