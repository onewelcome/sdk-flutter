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
        val data = Gson().toJson(CustomTwoStepRegistrationModel(customInfo.data, customInfo.status,providerId))
        OneginiEventsSender.events?.success(Gson().toJson(OneginiEvent(Constants.EVENT_OPEN_CUSTOM_TWO_STEP_REGISTRATION_SCREEN, data)))
    }

    companion object {
        var CALLBACK: OneginiCustomRegistrationCallback? = null
    }
}
