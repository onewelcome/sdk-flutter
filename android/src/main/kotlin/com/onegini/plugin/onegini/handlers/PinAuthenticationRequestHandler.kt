package com.onegini.plugin.onegini.handlers

import com.google.gson.Gson
import com.onegini.mobile.sdk.android.handlers.request.OneginiPinAuthenticationRequestHandler
import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiPinCallback
import com.onegini.mobile.sdk.android.model.entity.AuthenticationAttemptCounter
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.plugin.onegini.constants.Constants
import com.onegini.plugin.onegini.helpers.OneginiEventsSender
import com.onegini.plugin.onegini.models.OneginiEvent

class PinAuthenticationRequestHandler : OneginiPinAuthenticationRequestHandler {
    companion object{
        var CALLBACK: OneginiPinCallback ? = null

    }

    override fun startAuthentication(userProfile: UserProfile?, oneginiPinCallback: OneginiPinCallback?, attemptCounter: AuthenticationAttemptCounter?) {
        CALLBACK = oneginiPinCallback
        OneginiEventsSender.events?.success(Constants.EVENT_OPEN_PIN_AUTH)

    }

    override fun onNextAuthenticationAttempt(attemptCounter: AuthenticationAttemptCounter?) {
       OneginiEventsSender.events?.success(Gson().toJson(OneginiEvent(Constants.EVENT_NEXT_AUTHENTICATION_ATTEMPT,Gson().toJson(attemptCounter).toString())))
    }

    override fun finishAuthentication() {
        OneginiEventsSender.events?.success(Constants.EVENT_CLOSE_PIN)
    }

}