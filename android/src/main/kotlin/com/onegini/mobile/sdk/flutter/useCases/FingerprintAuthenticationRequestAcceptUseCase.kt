package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.FINGERPRINT_AUTHENTICATION_NOT_IN_PROGRESS
import com.onegini.mobile.sdk.flutter.handlers.FingerprintAuthenticationRequestHandler
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class FingerprintAuthenticationRequestAcceptUseCase @Inject constructor() {
  operator fun invoke(): Result<Unit> {
    return when (val fingerprintCallback = FingerprintAuthenticationRequestHandler.fingerprintCallback) {
      null -> Result.failure(SdkError(FINGERPRINT_AUTHENTICATION_NOT_IN_PROGRESS).pigeonError())
      else -> {
        fingerprintCallback.acceptAuthenticationRequest()
        Result.success(Unit)
      }
    }
  }
}
