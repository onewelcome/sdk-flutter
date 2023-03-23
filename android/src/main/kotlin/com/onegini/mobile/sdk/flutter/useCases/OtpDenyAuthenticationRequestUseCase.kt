package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.OTP_AUTHENTICATION_NOT_IN_PROGRESS
import com.onegini.mobile.sdk.flutter.handlers.MobileAuthOtpRequestHandler
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class OtpDenyAuthenticationRequestUseCase @Inject constructor() {
  operator fun invoke(): Result<Unit> {
    MobileAuthOtpRequestHandler.CALLBACK?.denyAuthenticationRequest()

    return when (val otpCallback = MobileAuthOtpRequestHandler.CALLBACK) {
      null -> Result.failure(SdkError(OTP_AUTHENTICATION_NOT_IN_PROGRESS).pigeonError())
      else -> {
        otpCallback.denyAuthenticationRequest()
        MobileAuthOtpRequestHandler.CALLBACK = null
        Result.success(Unit)
      }
    }
  }
}
