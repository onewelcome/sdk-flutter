package com.onegini.mobile.sdk.flutter.handlers

import com.onegini.mobile.sdk.android.handlers.request.OneginiMobileAuthWithPushFingerprintRequestHandler
import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiFingerprintCallback
import com.onegini.mobile.sdk.android.model.entity.OneginiMobileAuthenticationRequest
import javax.inject.Inject

class MobileAuthWithPushFingerprintRequestHandler @Inject constructor(private val fingerprintAuthenticationRequestHandler: FingerprintAuthenticationRequestHandler) :
  OneginiMobileAuthWithPushFingerprintRequestHandler {
  override fun startAuthentication(request: OneginiMobileAuthenticationRequest, oneginiFingerprintCallback: OneginiFingerprintCallback) {
    fingerprintAuthenticationRequestHandler.startAuthentication(request.userProfile, oneginiFingerprintCallback)
  }

  override fun onNextAuthenticationAttempt() {
    fingerprintAuthenticationRequestHandler.onNextAuthenticationAttempt()
  }

  override fun onFingerprintCaptured() {
    fingerprintAuthenticationRequestHandler.onFingerprintCaptured()
  }

  override fun finishAuthentication() {
    fingerprintAuthenticationRequestHandler.finishAuthentication()
  }
}