package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.flutter.handlers.PinRequestHandler
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.REGISTRATION_NOT_IN_PROGRESS

class SubmitPinRegistrationRequestUseCase {
  operator fun invoke(pin: String?): Result<Unit> {
    if (PinRequestHandler.CALLBACK == null) {
      return Result.failure(SdkError(REGISTRATION_NOT_IN_PROGRESS).pigeonError())
    }

    when (pin) {
      null -> {
        PinRequestHandler.CALLBACK?.denyAuthenticationRequest()
      }
      else -> {
        PinRequestHandler.CALLBACK?.acceptAuthenticationRequest(pin.toCharArray())
      }
    }

    return Result.success(Unit)
  }
}
