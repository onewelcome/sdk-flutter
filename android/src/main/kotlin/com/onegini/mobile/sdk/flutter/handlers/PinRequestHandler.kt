package com.onegini.mobile.sdk.flutter.handlers

import com.google.gson.Gson
import com.onegini.mobile.sdk.android.handlers.error.OneginiPinValidationError
import com.onegini.mobile.sdk.android.handlers.request.OneginiCreatePinRequestHandler
import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiPinCallback
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.constants.Constants
import com.onegini.mobile.sdk.flutter.helpers.OneginiEventsSender
import com.onegini.mobile.sdk.flutter.models.Error
import com.onegini.mobile.sdk.flutter.models.OneginiEvent

class PinRequestHandler : OneginiCreatePinRequestHandler {

    companion object {
        var CALLBACK: OneginiPinCallback? = null
    }



    override fun startPinCreation(userProfile: UserProfile?, oneginiPinCallback: OneginiPinCallback, p2: Int) {
        CALLBACK = oneginiPinCallback
        OneginiEventsSender.events?.success(Constants.EVENT_OPEN_PIN)
    }

    override fun onNextPinCreationAttempt(oneginiPinValidationError: OneginiPinValidationError) {
        OneginiEventsSender.events?.success(Gson().toJson(OneginiEvent(Constants.EVENT_ERROR,Gson().toJson(Error(oneginiPinValidationError.errorType.toString(),oneginiPinValidationError.message ?:"")).toString())))
    }

    override fun finishPinCreation() {
        OneginiEventsSender.events?.success(Constants.EVENT_CLOSE_PIN)
    }
}