package com.onegini.mobile.sdk.flutter.handlers

import com.onegini.mobile.sdk.android.handlers.request.OneginiPinAuthenticationRequestHandler
import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiPinCallback
import com.onegini.mobile.sdk.android.model.entity.AuthenticationAttemptCounter
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.NOT_IN_PROGRESS_AUTHENTICATION
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import com.onegini.mobile.sdk.flutter.pigeonPlugin.NativeCallFlutterApi
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWAuthenticationAttempt
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class PinAuthenticationRequestHandler @Inject constructor(private val nativeApi: NativeCallFlutterApi) :
  OneginiPinAuthenticationRequestHandler {
  private var callback: OneginiPinCallback? = null

  override fun startAuthentication(
    userProfile: UserProfile,
    oneginiPinCallback: OneginiPinCallback,
    attemptCounter: AuthenticationAttemptCounter
  ) {
    callback = oneginiPinCallback
    nativeApi.n2fOpenPinAuthentication { }
  }

  override fun onNextAuthenticationAttempt(attemptCounter: AuthenticationAttemptCounter) {
    val authenticationAttempt = OWAuthenticationAttempt(
      attemptCounter.failedAttempts.toLong(),
      attemptCounter.maxAttempts.toLong(),
      attemptCounter.remainingAttempts.toLong()
    )
    nativeApi.n2fNextPinAuthenticationAttempt(authenticationAttempt) {}
  }

  override fun finishAuthentication() {
    nativeApi.n2fClosePinAuthentication { }
    callback = null
  }

  fun acceptAuthenticationRequest(pin: CharArray): Result<Unit> {
    return callback?.let {
      it.acceptAuthenticationRequest(pin)
      Result.success(Unit)
    } ?: Result.failure(SdkError(NOT_IN_PROGRESS_AUTHENTICATION).pigeonError())
  }

  fun denyAuthenticationRequest(): Result<Unit> {
    return callback?.let {
      it.denyAuthenticationRequest()
      Result.success(Unit)
    } ?: Result.failure(SdkError(NOT_IN_PROGRESS_AUTHENTICATION).pigeonError())
  }
}
