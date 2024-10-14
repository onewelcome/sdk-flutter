package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.flutter.handlers.BiometricAuthenticationRequestHandler
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class BiometricAuthenticationRequestDenyUseCase @Inject constructor(private val biometricAuthenticationRequestHandler: BiometricAuthenticationRequestHandler) {
  operator fun invoke(): Result<Unit> {
    return biometricAuthenticationRequestHandler.denyAuthenticationRequest()
  }
}
