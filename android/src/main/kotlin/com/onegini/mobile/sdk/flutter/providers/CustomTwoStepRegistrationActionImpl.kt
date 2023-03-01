package com.onegini.mobile.sdk.flutter.providers

import com.google.gson.Gson
import com.onegini.mobile.sdk.android.handlers.action.OneginiCustomRegistrationAction
import com.onegini.mobile.sdk.android.handlers.action.OneginiCustomTwoStepRegistrationAction
import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiCustomRegistrationCallback
import com.onegini.mobile.sdk.android.model.entity.CustomInfo
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.REGISTRATION_NOT_IN_PROGRESS
import com.onegini.mobile.sdk.flutter.constants.Constants
import com.onegini.mobile.sdk.flutter.errors.wrapperError
import com.onegini.mobile.sdk.flutter.helpers.OneginiEventsSender
import com.onegini.mobile.sdk.flutter.models.CustomRegistrationModel
import com.onegini.mobile.sdk.flutter.models.OneginiEvent
import io.flutter.plugin.common.MethodChannel

class CustomTwoStepRegistrationActionImpl(private val providerId: String) : OneginiCustomTwoStepRegistrationAction, CustomRegistrationAction {
    var callback: OneginiCustomRegistrationCallback? = null

    override fun initRegistration(callback: OneginiCustomRegistrationCallback, info: CustomInfo?) {
        this.callback = callback

        val data = Gson().toJson(CustomRegistrationModel(info?.data.orEmpty(), info?.status, providerId))
        OneginiEventsSender.events?.success(Gson().toJson(OneginiEvent(Constants.EVENT_INIT_CUSTOM_REGISTRATION, data)))
    }

    override fun finishRegistration(callback: OneginiCustomRegistrationCallback, customInfo: CustomInfo?) {
        this.callback = callback

        val data = Gson().toJson(CustomRegistrationModel(customInfo?.data.orEmpty(), customInfo?.status, providerId))
        OneginiEventsSender.events?.success(Gson().toJson(OneginiEvent(Constants.EVENT_FINISH_CUSTOM_REGISTRATION, data)))
    }

    override fun getCustomRegistrationAction(): OneginiCustomRegistrationAction {
        return this
    }

    override fun getIdProvider(): String {
        return providerId
    }

    override fun returnSuccess(result: String?, resultChannel: MethodChannel.Result) {
        when (callback) {
            null -> resultChannel.wrapperError(REGISTRATION_NOT_IN_PROGRESS)
            else -> this.callback?.returnSuccess(result)
        }

        callback = null
    }

    override fun returnError(exception: Exception?, resultChannel: MethodChannel.Result) {
        when (callback) {
            null -> resultChannel.wrapperError(REGISTRATION_NOT_IN_PROGRESS)
            else -> this.callback?.returnError(exception)
        }

        callback = null
    }
}
