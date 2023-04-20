package com.onegini.mobile.sdk.flutter.providers

import com.onegini.mobile.sdk.android.handlers.action.OneginiCustomRegistrationAction
import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiCustomRegistrationCallback
import com.onegini.mobile.sdk.android.model.entity.CustomInfo
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.NOT_IN_PROGRESS_REGISTRATION
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import com.onegini.mobile.sdk.flutter.mapToOwCustomInfo
import com.onegini.mobile.sdk.flutter.pigeonPlugin.NativeCallFlutterApi

class CustomRegistrationActionImpl(private val providerId: String, private val nativeApi: NativeCallFlutterApi) : OneginiCustomRegistrationAction, CustomRegistrationAction {
  var callback: OneginiCustomRegistrationCallback? = null

  override fun isInProgress(): Boolean {
    return callback != null
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
    } ?: Result.failure(SdkError(NOT_IN_PROGRESS_REGISTRATION).pigeonError())
  }

  override fun returnError(exception: Exception?): Result<Unit> {
    return callback?.let { customRegistrationCallback ->
      customRegistrationCallback.returnError(exception)
      callback = null
      Result.success(Unit)
    } ?: Result.failure(SdkError(NOT_IN_PROGRESS_REGISTRATION).pigeonError())
  }
}
