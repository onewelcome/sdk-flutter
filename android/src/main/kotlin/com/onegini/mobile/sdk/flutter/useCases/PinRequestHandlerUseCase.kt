package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiPinCallback
import io.flutter.plugin.common.MethodCall

class PinRequestHandlerUseCase(private val oneginiPinCallback: OneginiPinCallback?) {
    fun acceptAuthenticationRequest(call: MethodCall) {
        val pin = call.argument<String>("pin")?.toCharArray()
        oneginiPinCallback?.acceptAuthenticationRequest(pin)
    }

    fun denyAuthenticationRequest() {
        oneginiPinCallback?.denyAuthenticationRequest()
    }
}