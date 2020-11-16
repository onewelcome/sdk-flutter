package com.example.onegini_test.handlers

import android.content.Context
import com.onegini.mobile.sdk.android.handlers.request.OneginiPinAuthenticationRequestHandler
import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiPinCallback
import com.onegini.mobile.sdk.android.model.entity.AuthenticationAttemptCounter
import com.onegini.mobile.sdk.android.model.entity.UserProfile

class PinAuthenticationRequestHandler(var context: Context?) : OneginiPinAuthenticationRequestHandler {
    companion object{
        var CALLBACK: OneginiPinCallback ? = null

    }
    override fun startAuthentication(userProfile: UserProfile?, oneginiPinCallback: OneginiPinCallback?, attemptCounter: AuthenticationAttemptCounter?) {
        var userProfileId = userProfile?.profileId
        CALLBACK = oneginiPinCallback

    }

    override fun onNextAuthenticationAttempt(p0: AuthenticationAttemptCounter?) {
        TODO("Not yet implemented")
    }

    override fun finishAuthentication() {
        TODO("Not yet implemented")
    }

}