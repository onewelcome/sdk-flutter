package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.flutter.errors.FlutterPluginException
import com.onegini.mobile.sdk.flutter.handlers.PinAuthenticationRequestHandler
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class PinAuthenticationRequestAcceptUseCase @Inject constructor(private val pinAuthenticationRequestHandler: PinAuthenticationRequestHandler) {
  operator fun invoke(pin: String): Result<Unit> {
    return pinAuthenticationRequestHandler.acceptAuthenticationRequest(pin.toCharArray())
  }
}
