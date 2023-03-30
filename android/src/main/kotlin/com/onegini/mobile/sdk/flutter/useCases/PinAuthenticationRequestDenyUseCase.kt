package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.AUTHENTICATION_NOT_IN_PROGRESS
import com.onegini.mobile.sdk.flutter.handlers.PinAuthenticationRequestHandler
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class PinAuthenticationRequestDenyUseCase @Inject constructor() {
  operator fun invoke(): Result<Unit> {
    return when (val pinCallback = PinAuthenticationRequestHandler.callback) {
      null -> Result.failure(SdkError(AUTHENTICATION_NOT_IN_PROGRESS).pigeonError())
      else -> {
        pinCallback.denyAuthenticationRequest()
        Result.success(Unit)
      }
    }
  }
}
