package com.onegini.mobile.sdk.flutter.facade

import javax.inject.Inject
import javax.inject.Singleton
import android.app.Activity
import androidx.fragment.app.FragmentActivity
import androidx.biometric.BiometricPrompt
import androidx.core.content.ContextCompat
import com.onegini.mobile.sdk.flutter.handlers.BiometricAuthenticationRequestHandler
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWBiometricMessages

@Singleton
class BiometricPromptFacadeImpl @Inject constructor() : BiometricPromptFacade {

  private lateinit var biometricPrompt: BiometricPrompt

  override fun showPrompt(biometricMessages: OWBiometricMessages, activity: Activity, biometricRequestHandler: BiometricAuthenticationRequestHandler) {
    val fragmentActivity = activity as FragmentActivity
    biometricPrompt = BiometricPrompt(fragmentActivity, ContextCompat.getMainExecutor(fragmentActivity), object: BiometricPrompt.AuthenticationCallback() {
      override fun onAuthenticationError(errorCode: Int, errString: CharSequence) {
        biometricRequestHandler.CALLBACK?.onBiometricAuthenticationError(errorCode)
      }

      override fun onAuthenticationSucceeded(result: BiometricPrompt.AuthenticationResult) {
        biometricRequestHandler.CALLBACK?.userAuthenticatedSuccessfully()
      }

      override fun onAuthenticationFailed() {
      }
    })

    val promptInfo: BiometricPrompt.PromptInfo = BiometricPrompt.PromptInfo.Builder()
      .setTitle(biometricMessages.title)
      .setSubtitle(biometricMessages.subTitle)
      .setNegativeButtonText(biometricMessages.negativeButtonText)
      .setDescription(biometricMessages.description)
      .build()
    biometricPrompt.authenticate(promptInfo, biometricRequestHandler.CRYPTO_OBJECT!!)
  }

  override fun closePrompt() {
    biometricPrompt.cancelAuthentication()
  }
}