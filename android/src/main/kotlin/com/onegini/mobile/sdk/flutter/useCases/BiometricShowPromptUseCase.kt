package com.onegini.mobile.sdk.flutter.useCases

import android.app.Activity
import androidx.fragment.app.FragmentActivity
import androidx.biometric.BiometricPrompt
import androidx.core.content.ContextCompat
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.BIOMETRIC_AUTHENTICATION_NOT_IN_PROGRESS
import com.onegini.mobile.sdk.flutter.handlers.BiometricAuthenticationRequestHandler
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWBiometricMessages
import com.onegini.mobile.sdk.flutter.facade.BiometricPromptFacade
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class BiometricShowPromptUseCase @Inject constructor(private val activity: Activity,
                                                     private val biometricAuthRequestHandler: BiometricAuthenticationRequestHandler,
                                                     private val biometricPromptFacade: BiometricPromptFacade) {
  operator fun invoke(messages: OWBiometricMessages, callback: (Result<Unit>) -> Unit) {
    if (biometricAuthRequestHandler.CALLBACK == null) {
      return callback(Result.failure(SdkError(BIOMETRIC_AUTHENTICATION_NOT_IN_PROGRESS).pigeonError()))
    }
    biometricPromptFacade.showPrompt(messages, activity, biometricAuthRequestHandler)
    return callback(Result.success(Unit))
  }
}