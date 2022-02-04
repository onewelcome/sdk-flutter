package com.onegini.mobile.sdk.flutter.providers

import com.google.gson.Gson
import com.onegini.mobile.sdk.android.handlers.action.OneginiCustomTwoStepRegistrationAction
import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiCustomRegistrationCallback
import com.onegini.mobile.sdk.android.model.entity.CustomInfo
import com.onegini.mobile.sdk.flutter.constants.Constants
import com.onegini.mobile.sdk.flutter.helpers.OneginiEventsSender
import com.onegini.mobile.sdk.flutter.models.CustomTwoStepRegistrationModel
import com.onegini.mobile.sdk.flutter.models.Error
import com.onegini.mobile.sdk.flutter.models.OneginiEvent

class CustomTwoStepRegistrationAction(private val providerId: String) : OneginiCustomTwoStepRegistrationAction {

    override fun initRegistration(callback: OneginiCustomRegistrationCallback, customInfo: CustomInfo?) {
        callback.returnSuccess(null)
    }

    override fun finishRegistration(callback: OneginiCustomRegistrationCallback, customInfo: CustomInfo?) {
        CALLBACK = callback
        // TODO
        // I don't think this implementation is valid, but if it works for CZ I will leave it as it is, just added
        // the required null checks. Has to be refactored
        if (customInfo != null) {
            if (customInfo.status < 2001) {
                val data = Gson().toJson(CustomTwoStepRegistrationModel(customInfo.data.orEmpty(), providerId))
                OneginiEventsSender.events?.success(Gson().toJson(OneginiEvent(Constants.EVENT_OPEN_CUSTOM_TWO_STEP_REGISTRATION_SCREEN, data)))
            } else {
                val error = Error(customInfo.status.toString(), customInfo.data.orEmpty())
                OneginiEventsSender.events?.success(Gson().toJson(OneginiEvent(Constants.EVENT_ERROR, Gson().toJson(error).toString())))
            }
        }
    }

    companion object {
        var CALLBACK: OneginiCustomRegistrationCallback? = null
    }
}
