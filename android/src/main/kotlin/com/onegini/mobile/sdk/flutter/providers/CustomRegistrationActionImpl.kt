package com.onegini.mobile.sdk.flutter.providers

import com.google.gson.Gson
import com.onegini.mobile.sdk.android.handlers.action.OneginiCustomRegistrationAction
import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiCustomRegistrationCallback
import com.onegini.mobile.sdk.android.model.entity.CustomInfo
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.REGISTRATION_NOT_IN_PROGRESS
import com.onegini.mobile.sdk.flutter.constants.Constants
import com.onegini.mobile.sdk.flutter.helpers.OneginiEventsSender
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import com.onegini.mobile.sdk.flutter.models.CustomRegistrationModel
import com.onegini.mobile.sdk.flutter.models.OneginiEvent

class CustomRegistrationActionImpl(private val providerId: String) : OneginiCustomRegistrationAction, CustomRegistrationAction {
    var callback: OneginiCustomRegistrationCallback? = null

    override fun finishRegistration(callback: OneginiCustomRegistrationCallback, info: CustomInfo?) {
        this.callback = callback

        // Example Tell flutter to start this method from native
//        onewelcomeEventApi.testEventFunction("customOneStepOnFinish") { }

        val data = Gson().toJson(CustomRegistrationModel(info?.data.orEmpty(), info?.status, providerId))
        OneginiEventsSender.events?.success(Gson().toJson(OneginiEvent(Constants.EVENT_FINISH_CUSTOM_REGISTRATION, data)))

    }

    override fun getCustomRegistrationAction(): OneginiCustomRegistrationAction {
        return this
    }

    override fun getIdProvider(): String {
        return providerId
    }

    override fun returnSuccess(result: String?, pigeonCallback: (Result<Unit>) -> Unit) {
        when (callback) {
            null -> pigeonCallback(Result.failure(SdkError(REGISTRATION_NOT_IN_PROGRESS).pigeonError()))
            else -> {
                this.callback?.returnSuccess(result)
                pigeonCallback(Result.success(Unit))
            }
        }

        callback = null
    }

    override fun returnError(exception: Exception?, pigeonCallback: (Result<Unit>) -> Unit) {
        when (callback) {
            null -> pigeonCallback(Result.failure(SdkError(REGISTRATION_NOT_IN_PROGRESS).pigeonError()))
            else -> {
                this.callback?.returnError(exception)
                pigeonCallback(Result.success(Unit))
            }
        }

        callback = null
    }
}
