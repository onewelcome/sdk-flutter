package com.onegini.mobile.sdk.flutter.handlers

import com.onegini.mobile.sdk.android.handlers.error.OneginiPinValidationError
import com.onegini.mobile.sdk.android.handlers.request.OneginiCreatePinRequestHandler
import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiPinCallback
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.constants.Constants
import com.onegini.mobile.sdk.flutter.helpers.OneginiEventsSender

class PinRequestHandler : OneginiCreatePinRequestHandler {

    companion object {
        var CALLBACK: OneginiPinCallback? = null
    }



    override fun startPinCreation(userProfile: UserProfile?, oneginiPinCallback: OneginiPinCallback?, p2: Int) {
        CALLBACK = oneginiPinCallback
        OneginiEventsSender.events?.success(Constants.EVENT_OPEN_PIN)
    }

    override fun onNextPinCreationAttempt(oneginiPinValidationError: OneginiPinValidationError?) {
        OneginiEventsSender.events?.error(oneginiPinValidationError?.errorType.toString(), oneginiPinValidationError?.message, oneginiPinValidationError?.errorDetails)
    }

    override fun finishPinCreation() {
        OneginiEventsSender.events?.success(Constants.EVENT_CLOSE_PIN)
    }
}