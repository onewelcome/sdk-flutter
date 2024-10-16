package com.onegini.mobile.sdk.flutter.useCases

import android.app.Activity
import androidx.fragment.app.FragmentActivity
import androidx.biometric.BiometricPrompt
import androidx.core.content.ContextCompat
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.NOT_IN_PROGRESS_BIOMETRIC_AUTHENTICATION
import com.onegini.mobile.sdk.flutter.handlers.BiometricAuthenticationRequestHandler
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import com.onegini.mobile.sdk.flutter.helpers.BiometricAuthRequestType
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWBiometricMessages
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class BiometricAuthenticationUseCase @Inject constructor(private val activity: Activity,
                                                         private val biometricAuthRequestHandler: BiometricAuthenticationRequestHandler) {
  private lateinit var fragmentActivity: FragmentActivity
  private lateinit var biometricRequestHandler: BiometricAuthenticationRequestHandler
  private lateinit var biometricPrompt: BiometricPrompt
  private lateinit var biometricMessages: OWBiometricMessages

  operator fun invoke(requestType: BiometricAuthRequestType, messages: OWBiometricMessages, callback: (Result<Unit>) -> Unit) {
    biometricRequestHandler = biometricAuthRequestHandler

    if (biometricRequestHandler.CALLBACK == null) {
      return callback(Result.failure(SdkError(NOT_IN_PROGRESS_BIOMETRIC_AUTHENTICATION).pigeonError()))
    }

    when (requestType) {
      BiometricAuthRequestType.showprompt -> {
        fragmentActivity = activity as FragmentActivity
        this.biometricMessages = messages
        showPrompt()
      }
      BiometricAuthRequestType.fallbacktopin -> {
        biometricRequestHandler.CALLBACK!!.fallbackToPin()
        biometricPrompt.cancelAuthentication()
      }

      BiometricAuthRequestType.denyauthrequest -> {
        biometricRequestHandler.CALLBACK!!.denyAuthenticationRequest()
        biometricPrompt.cancelAuthentication()
      }
    }
    return callback(Result.success(Unit));
  }

  private fun showPrompt() {
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
}