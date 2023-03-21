package com.onegini.mobile.sdk.flutter.handlers

import com.google.gson.Gson
import com.onegini.mobile.sdk.android.handlers.request.OneginiMobileAuthWithOtpRequestHandler
import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiAcceptDenyCallback
import com.onegini.mobile.sdk.android.model.entity.OneginiMobileAuthenticationRequest
import com.onegini.mobile.sdk.flutter.constants.Constants
import com.onegini.mobile.sdk.flutter.models.OneginiEvent
import com.onegini.mobile.sdk.flutter.pigeonPlugin.NativeCallFlutterApi
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class MobileAuthOtpRequestHandler @Inject constructor(private val nativeApi: NativeCallFlutterApi): OneginiMobileAuthWithOtpRequestHandler {
    private var userProfileId: String? = null
    private var message: String? = null
    override fun startAuthentication(
            oneginiMobileAuthenticationRequest: OneginiMobileAuthenticationRequest,
            oneginiAcceptDenyCallback: OneginiAcceptDenyCallback
    ) {

        CALLBACK = oneginiAcceptDenyCallback
        userProfileId = oneginiMobileAuthenticationRequest.userProfile.profileId
        message = oneginiMobileAuthenticationRequest.message
        nativeApi.n2fOpenAuthOtp(message ?: "") {}
    }

    override fun finishAuthentication() {
        nativeApi.n2fCloseAuthOtp {}
    }

    companion object {
        var CALLBACK: OneginiAcceptDenyCallback? = null
    }
}
