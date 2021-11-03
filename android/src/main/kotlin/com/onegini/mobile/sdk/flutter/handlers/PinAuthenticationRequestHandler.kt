package com.onegini.mobile.sdk.flutter.handlers

import com.google.gson.Gson
import com.onegini.mobile.sdk.android.handlers.request.OneginiPinAuthenticationRequestHandler
import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiPinCallback
import com.onegini.mobile.sdk.android.model.entity.AuthenticationAttemptCounter
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.constants.Constants
import com.onegini.mobile.sdk.flutter.helpers.OneginiEventsSender
import com.onegini.mobile.sdk.flutter.models.OneginiEvent

class PinAuthenticationRequestHandler(private val oneginiEventsSender: OneginiEventsSender) : OneginiPinAuthenticationRequestHandler {
    companion object {
        var CALLBACK: OneginiPinCallback? = null
    }

    override fun startAuthentication(userProfile: UserProfile, oneginiPinCallback: OneginiPinCallback, attemptCounter: AuthenticationAttemptCounter?) {
        CALLBACK = oneginiPinCallback
        oneginiEventsSender.events?.success(Constants.EVENT_OPEN_PIN_AUTH)
    }

    override fun onNextAuthenticationAttempt(attemptCounter: AuthenticationAttemptCounter) {
        val attemptCounterJson = Gson().toJson(mapOf("maxAttempts" to attemptCounter.maxAttempts, "failedAttempts" to attemptCounter.failedAttempts, "remainingAttempts" to attemptCounter.remainingAttempts))
        oneginiEventsSender.events?.success(Gson().toJson(OneginiEvent(Constants.EVENT_NEXT_AUTHENTICATION_ATTEMPT, attemptCounterJson)))
    }

    override fun finishAuthentication() {
        oneginiEventsSender.events?.success(Constants.EVENT_CLOSE_PIN_AUTH)
    }
}
