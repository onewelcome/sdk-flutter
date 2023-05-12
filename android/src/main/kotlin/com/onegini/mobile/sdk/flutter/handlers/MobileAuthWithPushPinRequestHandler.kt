package com.onegini.mobile.sdk.flutter.handlers

import com.onegini.mobile.sdk.android.handlers.error.OneginiMobileAuthenticationError
import com.onegini.mobile.sdk.android.handlers.request.OneginiMobileAuthWithPushPinRequestHandler
import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiPinCallback
import com.onegini.mobile.sdk.android.model.entity.AuthenticationAttemptCounter
import com.onegini.mobile.sdk.android.model.entity.OneginiMobileAuthenticationRequest
import javax.inject.Inject

class MobileAuthWithPushPinRequestHandler @Inject constructor(private val pinAuthenticationRequestHandler: PinAuthenticationRequestHandler) : OneginiMobileAuthWithPushPinRequestHandler {
  override fun startAuthentication(
    request: OneginiMobileAuthenticationRequest,
    pinCallback: OneginiPinCallback,
    attemptCounter: AuthenticationAttemptCounter,
    error: OneginiMobileAuthenticationError?
  ) {
    pinAuthenticationRequestHandler.startAuthentication(request.userProfile, pinCallback, attemptCounter)
  }

  override fun onNextAuthenticationAttempt(attemptCounter: AuthenticationAttemptCounter) {
   pinAuthenticationRequestHandler.onNextAuthenticationAttempt(attemptCounter)
  }

  override fun finishAuthentication() {
    pinAuthenticationRequestHandler.finishAuthentication()
  }
}