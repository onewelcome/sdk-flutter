package com.onegini.mobile.sdk.flutter.handlers

import com.onegini.mobile.sdk.android.handlers.request.OneginiPinAuthenticationRequestHandler
import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiPinCallback
import com.onegini.mobile.sdk.android.model.entity.AuthenticationAttemptCounter
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.AUTHENTICATION_NOT_IN_PROGRESS
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
    nativeApi.n2fOpenPinScreenAuth { }
  }

  override fun onNextAuthenticationAttempt(attemptCounter: AuthenticationAttemptCounter) {
    val authenticationAttempt = OWAuthenticationAttempt(
      attemptCounter.failedAttempts.toLong(),
      attemptCounter.maxAttempts.toLong(),
      attemptCounter.remainingAttempts.toLong()
    )
    nativeApi.n2fNextAuthenticationAttempt(authenticationAttempt) {}
  }

  override fun finishAuthentication() {
    nativeApi.n2fClosePinAuth { }
    callback = null
  }

  fun acceptAuthenticationRequest(pin: CharArray): Result<Unit> {
    return callback?.let {
      it.acceptAuthenticationRequest(pin)
      Result.success(Unit)
    } ?: Result.failure(SdkError(AUTHENTICATION_NOT_IN_PROGRESS).pigeonError())
  }

  fun denyAuthenticationRequest(): Result<Unit> {
    return callback?.let {
      it.denyAuthenticationRequest()
      Result.success(Unit)
    } ?: Result.failure(SdkError(AUTHENTICATION_NOT_IN_PROGRESS).pigeonError())
  }
}
