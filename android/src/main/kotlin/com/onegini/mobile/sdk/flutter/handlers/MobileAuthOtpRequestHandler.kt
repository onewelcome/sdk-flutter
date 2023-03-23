package com.onegini.mobile.sdk.flutter.handlers

import com.onegini.mobile.sdk.android.handlers.request.OneginiMobileAuthWithOtpRequestHandler
import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiAcceptDenyCallback
import com.onegini.mobile.sdk.android.model.entity.OneginiMobileAuthenticationRequest
import com.onegini.mobile.sdk.flutter.pigeonPlugin.NativeCallFlutterApi
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class MobileAuthOtpRequestHandler @Inject constructor(private val nativeApi: NativeCallFlutterApi): OneginiMobileAuthWithOtpRequestHandler {
    override fun startAuthentication(
            oneginiMobileAuthenticationRequest: OneginiMobileAuthenticationRequest,
            oneginiAcceptDenyCallback: OneginiAcceptDenyCallback
    ) {
        CALLBACK = oneginiAcceptDenyCallback
        nativeApi.n2fOpenAuthOtp(oneginiMobileAuthenticationRequest.message) {}
    }

    override fun finishAuthentication() {
        nativeApi.n2fCloseAuthOtp {}
    }

    companion object {
        var CALLBACK: OneginiAcceptDenyCallback? = null
    }
}
