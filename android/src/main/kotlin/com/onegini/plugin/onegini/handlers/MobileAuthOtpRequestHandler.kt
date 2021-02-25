package com.onegini.plugin.onegini.handlers

import android.content.Context
import android.util.Log
import com.onegini.mobile.sdk.android.handlers.request.OneginiMobileAuthWithOtpRequestHandler
import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiAcceptDenyCallback
import com.onegini.mobile.sdk.android.model.entity.OneginiMobileAuthenticationRequest

class MobileAuthOtpRequestHandler(private val context: Context) : OneginiMobileAuthWithOtpRequestHandler {
    private var userProfileId: String? = null
    private var message: String? = null
    override fun startAuthentication(oneginiMobileAuthenticationRequest: OneginiMobileAuthenticationRequest,
                                     oneginiAcceptDenyCallback: OneginiAcceptDenyCallback) {
        
        Log.v("OTPRequest","test")
        CALLBACK = oneginiAcceptDenyCallback
        userProfileId = oneginiMobileAuthenticationRequest.userProfile.profileId
        message = oneginiMobileAuthenticationRequest.message
        //notifyActivity(COMMAND_START)
    }

    override fun finishAuthentication() {
       // notifyActivity(COMMAND_FINISH)
    }
    companion object {
        var CALLBACK: OneginiAcceptDenyCallback? = null
    }

}