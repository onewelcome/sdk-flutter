package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.flutter.OneginiSDK
import io.flutter.plugin.common.MethodCall

class PinAuthenticationUseCase(private val oneginiSDK: OneginiSDK) {

    fun acceptAuthenticationRequest(call: MethodCall) {
        val pin: CharArray? = call.argument<String>("pin")?.toCharArray()
        oneginiSDK.getPinAuthenticationRequestHandler().oneginiPinCallback?.acceptAuthenticationRequest(pin)
    }

    fun denyAuthenticationRequest() {
        oneginiSDK.getPinAuthenticationRequestHandler().oneginiPinCallback?.denyAuthenticationRequest()
    }
}