package com.onegini.mobile.sdk.flutter.handlers

import androidx.biometric.BiometricPrompt
import com.onegini.mobile.sdk.android.handlers.request.OneginiBiometricAuthenticationRequestHandler
import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiBiometricCallback
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.pigeonPlugin.NativeCallFlutterApi
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.NOT_IN_PROGRESS_BIOMETRIC_AUTHENTICATION
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class BiometricAuthenticationRequestHandler @Inject constructor(private val nativeApi: NativeCallFlutterApi) :
  OneginiBiometricAuthenticationRequestHandler {

  var CALLBACK: OneginiBiometricCallback? = null
  var CRYPTO_OBJECT: BiometricPrompt.CryptoObject? = null

  override fun startAuthentication(userProfile: UserProfile, cryptoObject: BiometricPrompt.CryptoObject,
                                   oneginiBiometricCallback: OneginiBiometricCallback) {
    CALLBACK = oneginiBiometricCallback
    CRYPTO_OBJECT = cryptoObject
    nativeApi.n2fStartBiometricAuthentication { }
  }

  override fun finishAuthentication() {
    CALLBACK = null
    CRYPTO_OBJECT = null
    nativeApi.n2fFinishBiometricAuthentication { }
  }
}