package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.AUTHENTICATION_NOT_IN_PROGRESS
import com.onegini.mobile.sdk.flutter.handlers.PinAuthenticationRequestHandler
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class SubmitPinAuthenticationRequestUseCase @Inject constructor() {
  operator fun invoke(pin: String?): Result<Unit> {
    if (PinAuthenticationRequestHandler.CALLBACK == null) {
      return Result.failure(SdkError(AUTHENTICATION_NOT_IN_PROGRESS).pigeonError())
    }

    when (pin) {
      null -> {
        PinAuthenticationRequestHandler.CALLBACK?.denyAuthenticationRequest()
      }
      else -> {
        PinAuthenticationRequestHandler.CALLBACK?.acceptAuthenticationRequest(pin.toCharArray())
      }
    }

    return Result.success(Unit)
  }
}
