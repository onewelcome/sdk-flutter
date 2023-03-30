package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.flutter.handlers.MobileAuthOtpRequestHandler
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class OtpAcceptAuthenticationRequestUseCase @Inject constructor() {
  operator fun invoke(): Result<Unit> {
    return MobileAuthOtpRequestHandler.acceptAuthenticationRequest()
  }
}
