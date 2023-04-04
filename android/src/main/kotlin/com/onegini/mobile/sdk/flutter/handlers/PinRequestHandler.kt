package com.onegini.mobile.sdk.flutter.handlers

import com.onegini.mobile.sdk.android.handlers.error.OneginiPinValidationError
import com.onegini.mobile.sdk.android.handlers.request.OneginiCreatePinRequestHandler
import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiPinCallback
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.PIN_CREATION_NOT_IN_PROGRESS
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import com.onegini.mobile.sdk.flutter.pigeonPlugin.NativeCallFlutterApi
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWOneginiError
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class PinRequestHandler @Inject constructor(private val nativeApi: NativeCallFlutterApi) : OneginiCreatePinRequestHandler {

  private var callback: OneginiPinCallback? = null

  override fun startPinCreation(userProfile: UserProfile, oneginiPinCallback: OneginiPinCallback, p2: Int) {
    callback = oneginiPinCallback
    nativeApi.n2fOpenPinRequestScreen { }
  }

  override fun onNextPinCreationAttempt(oneginiPinValidationError: OneginiPinValidationError) {
    nativeApi.n2fEventPinNotAllowed(
      OWOneginiError(
        oneginiPinValidationError.errorType.toLong(),
        oneginiPinValidationError.message ?: ""
      )
    ) {}
  }

  override fun finishPinCreation() {
    callback = null
    nativeApi.n2fClosePin { }
  }

  fun onPinProvided(pin: CharArray): Result<Unit> {
    return callback?.let {
      it.acceptAuthenticationRequest(pin)
      Result.success(Unit)
    } ?: Result.failure(SdkError(PIN_CREATION_NOT_IN_PROGRESS).pigeonError())
  }

  fun cancelPin(): Result<Unit> {
    return callback?.let {
      it.denyAuthenticationRequest()
      Result.success(Unit)
    } ?: Result.failure(SdkError(PIN_CREATION_NOT_IN_PROGRESS).pigeonError())
  }
}
