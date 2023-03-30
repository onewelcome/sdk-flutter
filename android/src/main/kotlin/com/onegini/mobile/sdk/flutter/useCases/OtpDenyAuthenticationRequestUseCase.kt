package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.flutter.handlers.MobileAuthOtpRequestHandler
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class OtpDenyAuthenticationRequestUseCase @Inject constructor(private val mobileAuthOtpRequestHandler: MobileAuthOtpRequestHandler) {
  operator fun invoke(): Result<Unit> {
    return mobileAuthOtpRequestHandler.denyAuthenticationRequest()
  }
}
