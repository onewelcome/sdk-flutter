package com.onegini.mobile.sdk.flutter.providers

import com.onegini.mobile.sdk.android.handlers.action.OneginiCustomRegistrationAction
import com.onegini.mobile.sdk.android.handlers.action.OneginiCustomTwoStepRegistrationAction
import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiCustomRegistrationCallback
import com.onegini.mobile.sdk.android.model.entity.CustomInfo
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import com.onegini.mobile.sdk.flutter.mapToOwCustomInfo
import com.onegini.mobile.sdk.flutter.pigeonPlugin.NativeCallFlutterApi
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWCustomInfo
import javax.inject.Inject

class CustomTwoStepRegistrationActionImpl(private val providerId: String, private val nativeApi: NativeCallFlutterApi) : OneginiCustomTwoStepRegistrationAction, CustomRegistrationAction {
    var callback: OneginiCustomRegistrationCallback? = null

    override fun initRegistration(callback: OneginiCustomRegistrationCallback, info: CustomInfo?) {
        this.callback = callback
        nativeApi.n2fEventInitCustomRegistration(info?.mapToOwCustomInfo(), providerId) {}
    }

    override fun finishRegistration(callback: OneginiCustomRegistrationCallback, info: CustomInfo?) {
        this.callback = callback
        nativeApi.n2fEventFinishCustomRegistration(info?.mapToOwCustomInfo(), providerId) {}
    }

    override fun getCustomRegistrationAction(): OneginiCustomRegistrationAction {
        return this
    }

    override fun getIdProvider(): String {
        return providerId
    }

    override fun returnSuccess(result: String?): Result<Unit> {
        return callback?.let { customRegistrationCallback ->
            customRegistrationCallback.returnSuccess(result)
            callback = null
            Result.success(Unit)
        } ?: Result.failure(SdkError(OneWelcomeWrapperErrors.REGISTRATION_NOT_IN_PROGRESS).pigeonError())
    }

    override fun returnError(exception: Exception?): Result<Unit> {
        return callback?.let { customRegistrationCallback ->
            customRegistrationCallback.returnError(exception)
            callback = null
            Result.success(Unit)
        } ?: Result.failure(SdkError(OneWelcomeWrapperErrors.REGISTRATION_NOT_IN_PROGRESS).pigeonError())
    }
}
