package com.onegini.mobile.sdk.flutter.handlers

import com.onegini.mobile.sdk.android.handlers.request.OneginiMobileAuthWithOtpRequestHandler
import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiAcceptDenyCallback
import com.onegini.mobile.sdk.android.model.entity.OneginiMobileAuthenticationRequest
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.NOT_IN_PROGRESS_OTP_AUTHENTICATION
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import com.onegini.mobile.sdk.flutter.pigeonPlugin.NativeCallFlutterApi
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class MobileAuthOtpRequestHandler @Inject constructor(private val nativeApi: NativeCallFlutterApi) :
  OneginiMobileAuthWithOtpRequestHandler {
  private var callback: OneginiAcceptDenyCallback? = null

  override fun startAuthentication(
    oneginiMobileAuthenticationRequest: OneginiMobileAuthenticationRequest,
    oneginiAcceptDenyCallback: OneginiAcceptDenyCallback
  ) {
    callback = oneginiAcceptDenyCallback
    nativeApi.n2fOpenAuthOtp(oneginiMobileAuthenticationRequest.message) {}
  }

  override fun finishAuthentication() {
    nativeApi.n2fCloseAuthOtp {}
    callback = null
  }

  fun acceptAuthenticationRequest(): Result<Unit> {
    return callback?.let {
      it.acceptAuthenticationRequest()
      Result.success(Unit)
    } ?: Result.failure(SdkError(NOT_IN_PROGRESS_OTP_AUTHENTICATION).pigeonError())
  }

  fun denyAuthenticationRequest(): Result<Unit> {
    return callback?.let {
      it.denyAuthenticationRequest()
      Result.success(Unit)
    } ?: Result.failure(SdkError(NOT_IN_PROGRESS_OTP_AUTHENTICATION).pigeonError())
  }
}
