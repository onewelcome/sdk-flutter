package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.flutter.handlers.FingerprintAuthenticationRequestHandler
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class FingerprintAuthenticationRequestAcceptUseCase @Inject constructor(private val fingerprintAuthenticationRequestHandler: FingerprintAuthenticationRequestHandler) {
  operator fun invoke(): Result<Unit> {
    return fingerprintAuthenticationRequestHandler.acceptAuthenticationRequest()
  }
}
