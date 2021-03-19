package com.onegini.mobile.sdk.flutter.handlers

import com.google.gson.Gson
import com.onegini.mobile.sdk.android.handlers.request.OneginiMobileAuthWithOtpRequestHandler
import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiAcceptDenyCallback
import com.onegini.mobile.sdk.android.model.entity.OneginiMobileAuthenticationRequest
import com.onegini.mobile.sdk.flutter.constants.Constants
import com.onegini.mobile.sdk.flutter.helpers.OneginiEventsSender
import com.onegini.mobile.sdk.flutter.models.OneginiEvent

class MobileAuthOtpRequestHandler : OneginiMobileAuthWithOtpRequestHandler {
    private var userProfileId: String? = null
    private var message: String? = null
    override fun startAuthentication(oneginiMobileAuthenticationRequest: OneginiMobileAuthenticationRequest,
                                     oneginiAcceptDenyCallback: OneginiAcceptDenyCallback) {
        
        
        CALLBACK = oneginiAcceptDenyCallback
        userProfileId = oneginiMobileAuthenticationRequest.userProfile.profileId
        message = oneginiMobileAuthenticationRequest.message
        OneginiEventsSender.events?.success(Gson().toJson(OneginiEvent(Constants.EVENT_OPEN_AUTH_OTP, message ?:"")))
        
    }

    override fun finishAuthentication() {
        OneginiEventsSender.events?.success(Constants.EVENT_CLOSE_AUTH_OTP)
    }
    companion object {
        var CALLBACK: OneginiAcceptDenyCallback? = null
    }

}