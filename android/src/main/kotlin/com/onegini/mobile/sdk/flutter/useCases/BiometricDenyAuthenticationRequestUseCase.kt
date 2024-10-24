package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.flutter.handlers.BiometricAuthenticationRequestHandler
import com.onegini.mobile.sdk.flutter.facade.BiometricPromptFacade
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.BIOMETRIC_AUTHENTICATION_NOT_IN_PROGRESS
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class BiometricDenyAuthenticationRequestUseCase @Inject constructor(private val biometricAuthRequestHandler: BiometricAuthenticationRequestHandler,
                                                                    private val biometricPromptFacade: BiometricPromptFacade) {
  operator fun invoke(callback: (Result<Unit>) -> Unit){
    if (biometricAuthRequestHandler.CALLBACK == null) {
      return callback(Result.failure(SdkError(BIOMETRIC_AUTHENTICATION_NOT_IN_PROGRESS).pigeonError()))
    }
    biometricAuthRequestHandler.CALLBACK?.denyAuthenticationRequest()
    biometricPromptFacade.closePrompt()
    return callback(Result.success(Unit))
  }
}
