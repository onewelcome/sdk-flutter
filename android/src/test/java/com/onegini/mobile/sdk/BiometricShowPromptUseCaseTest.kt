package com.onegini.mobile.sdk

import android.app.Activity
import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiBiometricCallback
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.BIOMETRIC_AUTHENTICATION_NOT_IN_PROGRESS
import com.onegini.mobile.sdk.flutter.SdkErrorAssert
import com.onegini.mobile.sdk.flutter.handlers.BiometricAuthenticationRequestHandler
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWBiometricMessages
import com.onegini.mobile.sdk.flutter.pigeonPlugin.NativeCallFlutterApi
import com.onegini.mobile.sdk.flutter.useCases.BiometricShowPromptUseCase
import com.onegini.mobile.sdk.flutter.facade.BiometricPromptFacade
import androidx.biometric.BiometricPrompt
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Mock
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.verify
import org.mockito.kotlin.*

@RunWith(MockitoJUnitRunner::class)
class BiometricShowPromptUseCaseTest {
  @Mock
  lateinit var oneginiBiometricCallbackMock: OneginiBiometricCallback

  @Mock
  lateinit var cryptoObject: BiometricPrompt.CryptoObject

  @Mock
  lateinit var nativeApi: NativeCallFlutterApi

  @Mock
  lateinit var activity: Activity

  @Mock
  lateinit var callbackMock: (Result<Unit>) -> Unit

  @Mock
  private lateinit var biometricPromptFacade: BiometricPromptFacade

  private lateinit var biometricShowPromptUseCase: BiometricShowPromptUseCase

  private lateinit var biometricAuthenticationRequestHandler: BiometricAuthenticationRequestHandler

  @Before
  fun attach() {
    biometricAuthenticationRequestHandler = BiometricAuthenticationRequestHandler(nativeApi)
    biometricShowPromptUseCase = BiometricShowPromptUseCase(activity, biometricAuthenticationRequestHandler, biometricPromptFacade)
  }

  @Test
  fun `When no biometric authentication callback is set, Then it should resolve with an error`() {
    biometricShowPromptUseCase(OWBiometricMessages("", "", ""), callbackMock)

    argumentCaptor<Result<Unit>>().apply {
      verify(callbackMock).invoke(capture())
      SdkErrorAssert.assertEquals(BIOMETRIC_AUTHENTICATION_NOT_IN_PROGRESS, firstValue.exceptionOrNull())
    }
  }

  @Test
  fun `When biometric authentication callback is set, Then it should resolve successfully`() {
    whenBiometricHasStarted()

    biometricShowPromptUseCase(OWBiometricMessages("", "", ""), callbackMock)

    argumentCaptor<Result<Unit>>().apply {
      verify(callbackMock).invoke(capture())
      Assert.assertEquals(firstValue.getOrNull(), Unit)
    }
  }

  private fun whenBiometricHasStarted() {
    biometricAuthenticationRequestHandler.startAuthentication(UserProfile("123456"), cryptoObject, oneginiBiometricCallbackMock)
  }

}