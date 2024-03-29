package com.onegini.mobile.sdk.flutter.handlers

import com.onegini.mobile.sdk.android.handlers.request.OneginiFingerprintAuthenticationRequestHandler
import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiFingerprintCallback
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.NOT_IN_PROGRESS_FINGERPRINT_AUTHENTICATION
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import com.onegini.mobile.sdk.flutter.pigeonPlugin.NativeCallFlutterApi
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class FingerprintAuthenticationRequestHandler @Inject constructor(private val nativeApi: NativeCallFlutterApi) :
  OneginiFingerprintAuthenticationRequestHandler {

  private var fingerprintCallback: OneginiFingerprintCallback? = null
  override fun startAuthentication(userProfile: UserProfile, oneginiFingerprintCallback: OneginiFingerprintCallback) {
    fingerprintCallback = oneginiFingerprintCallback
    nativeApi.n2fOpenFingerprintScreen { }
  }

  override fun onNextAuthenticationAttempt() {
    nativeApi.n2fNextFingerprintAuthenticationAttempt { }
  }

  override fun onFingerprintCaptured() {
    nativeApi.n2fShowScanningFingerprint { }
  }

  override fun finishAuthentication() {
    nativeApi.n2fCloseFingerprintScreen { }
  }

  fun acceptAuthenticationRequest(): Result<Unit> {
    return fingerprintCallback?.let {
      it.acceptAuthenticationRequest()
      Result.success(Unit)
    } ?: Result.failure(SdkError(NOT_IN_PROGRESS_FINGERPRINT_AUTHENTICATION).pigeonError())
  }

  fun denyAuthenticationRequest(): Result<Unit> {
    return fingerprintCallback?.let {
      it.denyAuthenticationRequest()
      Result.success(Unit)
    } ?: Result.failure(SdkError(NOT_IN_PROGRESS_FINGERPRINT_AUTHENTICATION).pigeonError())
  }

  fun fallbackToPin(): Result<Unit> {
    return fingerprintCallback?.let {
      it.fallbackToPin()
      Result.success(Unit)
    } ?: Result.failure(SdkError(NOT_IN_PROGRESS_FINGERPRINT_AUTHENTICATION).pigeonError())
  }
}
