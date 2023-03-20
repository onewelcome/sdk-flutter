package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.flutter.handlers.PinRequestHandler
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.REGISTRATION_NOT_IN_PROGRESS
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class PinRegistrationRequestDenyUseCase @Inject constructor() {
  operator fun invoke(): Result<Unit> {
    return when (val pinCallback = PinRequestHandler.CALLBACK) {
      null -> Result.failure(SdkError(REGISTRATION_NOT_IN_PROGRESS).pigeonError())
      else -> {
        pinCallback.denyAuthenticationRequest()
        Result.success(Unit)
      }
    }
  }
}
