package com.onegini.mobile.sdk.flutter.providers

import com.google.gson.Gson
import com.onegini.mobile.sdk.android.handlers.action.OneginiCustomRegistrationAction
import com.onegini.mobile.sdk.android.handlers.action.OneginiCustomTwoStepRegistrationAction
import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiCustomRegistrationCallback
import com.onegini.mobile.sdk.android.model.entity.CustomInfo
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors
import com.onegini.mobile.sdk.flutter.constants.Constants
import com.onegini.mobile.sdk.flutter.helpers.OneginiEventsSender
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import com.onegini.mobile.sdk.flutter.models.CustomRegistrationModel
import com.onegini.mobile.sdk.flutter.models.OneginiEvent

class CustomTwoStepRegistrationActionImpl(private val providerId: String) : OneginiCustomTwoStepRegistrationAction, CustomRegistrationAction {
    var callback: OneginiCustomRegistrationCallback? = null

    override fun initRegistration(callback: OneginiCustomRegistrationCallback, info: CustomInfo?) {
        this.callback = callback

        val data = Gson().toJson(CustomRegistrationModel(info?.data.orEmpty(), info?.status, providerId))
        OneginiEventsSender.events?.success(Gson().toJson(OneginiEvent(Constants.EVENT_INIT_CUSTOM_REGISTRATION, data)))
    }

    override fun finishRegistration(callback: OneginiCustomRegistrationCallback, customInfo: CustomInfo?) {
        this.callback = callback

//        onewelcomeEventApi.testEventFunction("custom2stepOnFinish") { }

        val data = Gson().toJson(CustomRegistrationModel(customInfo?.data.orEmpty(), customInfo?.status, providerId))
        OneginiEventsSender.events?.success(Gson().toJson(OneginiEvent(Constants.EVENT_FINISH_CUSTOM_REGISTRATION, data)))
    }

    override fun getCustomRegistrationAction(): OneginiCustomRegistrationAction {
        return this
    }

    override fun getIdProvider(): String {
        return providerId
    }

    override fun returnSuccess(result: String?, pigeonChannel: (Result<Unit>) -> Unit) {
        when (callback) {
            null -> pigeonChannel(Result.failure(SdkError(OneWelcomeWrapperErrors.REGISTRATION_NOT_IN_PROGRESS).pigeonError()))
            else -> {
                this.callback?.returnSuccess(result)
                pigeonChannel(Result.success(Unit))
            }
        }

        callback = null
    }

    override fun returnError(exception: Exception?, pigeonChannel: (Result<Unit>) -> Unit) {
        when (callback) {
            null -> pigeonChannel(Result.failure(SdkError(OneWelcomeWrapperErrors.REGISTRATION_NOT_IN_PROGRESS).pigeonError()))
            else -> {
                this.callback?.returnError(exception)
                pigeonChannel(Result.success(Unit))
            }
        }

        callback = null
    }
}
