package com.onegini.mobile.sdk.flutter.facade

import android.app.Activity
import com.onegini.mobile.sdk.flutter.handlers.BiometricAuthenticationRequestHandler
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWBiometricMessages

interface BiometricPromptFacade {
  fun showPrompt(messages: OWBiometricMessages, activity: Activity, biometricAuthRequestHandler: BiometricAuthenticationRequestHandler)
  fun closePrompt()
}