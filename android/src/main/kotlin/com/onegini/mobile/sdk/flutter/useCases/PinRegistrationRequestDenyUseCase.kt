package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.flutter.errors.FlutterPluginException
import com.onegini.mobile.sdk.flutter.handlers.PinRequestHandler
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class PinRegistrationRequestDenyUseCase @Inject constructor(private val pinRequestHandler: PinRequestHandler) {
  operator fun invoke(): Result<Unit> {
    return pinRequestHandler.cancelPin()
  }
}
