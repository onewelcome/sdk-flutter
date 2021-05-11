package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiAcceptDenyCallback

class MobileAuthOtpRequestHandlerUseCase(private val oneginiAcceptDenyCallback: OneginiAcceptDenyCallback?) {
    fun acceptAuthenticationRequest() {
        oneginiAcceptDenyCallback?.acceptAuthenticationRequest()
    }

    fun denyAuthenticationRequest() {
        oneginiAcceptDenyCallback?.denyAuthenticationRequest()
    }
}
