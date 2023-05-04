package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.flutter.handlers.PinRequestHandler
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class PinRegistrationRequestAcceptUseCase @Inject constructor(private val pinRequestHandler: PinRequestHandler) {
  operator fun invoke(pin: String): Result<Unit> {
    return pinRequestHandler.onPinProvided(pin.toCharArray())
  }
}
