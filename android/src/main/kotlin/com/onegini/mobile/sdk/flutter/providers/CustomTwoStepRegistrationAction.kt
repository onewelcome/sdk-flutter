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

    override fun finishRegistration(callback: OneginiCustomRegistrationCallback, customInfo: CustomInfo) {
        CALLBACK = callback
        if (customInfo.status < 2001) {
            val data = Gson().toJson(CustomTwoStepRegistrationModel(customInfo.data, providerId))
            OneginiEventsSender.events?.success(Gson().toJson(OneginiEvent(Constants.EVENT_OPEN_CUSTOM_TWO_STEP_REGISTRATION_SCREEN, data)))
        } else {
            OneginiEventsSender.events?.success(Gson().toJson(OneginiEvent(Constants.EVENT_ERROR, Gson().toJson(Error(customInfo.status.toString(), customInfo.data)).toString())))
        }
    }

    companion object {
        var CALLBACK: OneginiCustomRegistrationCallback? = null
    }
}
