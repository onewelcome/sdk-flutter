package com.onegini.mobile.sdk

import android.app.Activity
import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiBiometricCallback
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.BIOMETRIC_AUTHENTICATION_NOT_IN_PROGRESS
import com.onegini.mobile.sdk.flutter.SdkErrorAssert
import com.onegini.mobile.sdk.flutter.handlers.BiometricAuthenticationRequestHandler
import com.onegini.mobile.sdk.flutter.pigeonPlugin.NativeCallFlutterApi
import com.onegini.mobile.sdk.flutter.useCases.BiometricDenyAuthenticationRequestUseCase
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
class BiometricDenyAuthenticationRequestUseCaseTest {
  @Mock
  lateinit var oneginiBiometricCallbackMock: OneginiBiometricCallback

  @Mock
  lateinit var cryptoObject: BiometricPrompt.CryptoObject

  @Mock
  lateinit var nativeApi: NativeCallFlutterApi

  @Mock
  lateinit var callbackMock: (Result<Unit>) -> Unit

  @Mock
  private lateinit var biometricPromptFacade: BiometricPromptFacade

  private lateinit var biometricDenyAuthenticationRequestUseCase: BiometricDenyAuthenticationRequestUseCase

  private lateinit var biometricAuthenticationRequestHandler: BiometricAuthenticationRequestHandler

  @Before
  fun attach() {
    biometricAuthenticationRequestHandler = BiometricAuthenticationRequestHandler(nativeApi)
    biometricDenyAuthenticationRequestUseCase = BiometricDenyAuthenticationRequestUseCase(biometricAuthenticationRequestHandler, biometricPromptFacade)
  }

  @Test
  fun `When no biometric authentication callback is set, Then it should resolve with an error`() {
    biometricDenyAuthenticationRequestUseCase(callbackMock)

    argumentCaptor<Result<Unit>>().apply {
      verify(callbackMock).invoke(capture())
      SdkErrorAssert.assertEquals(BIOMETRIC_AUTHENTICATION_NOT_IN_PROGRESS, firstValue.exceptionOrNull())
    }
  }

  @Test
  fun `When biometric authentication callback is set, Then it should resolve successfully`() {
    whenBiometricHasStarted()

    biometricDenyAuthenticationRequestUseCase(callbackMock)

    argumentCaptor<Result<Unit>>().apply {
      verify(callbackMock).invoke(capture())
      Assert.assertEquals(firstValue.getOrNull(), Unit)
    }
  }

  @Test
  fun `When biometric authentication callback is set, Then it should call denyAuthenticationRequest on the sdk callback`() {
    whenBiometricHasStarted()

    biometricDenyAuthenticationRequestUseCase(callbackMock)

    verify(oneginiBiometricCallbackMock).denyAuthenticationRequest()
  }

  private fun whenBiometricHasStarted() {
    biometricAuthenticationRequestHandler.startAuthentication(UserProfile("123456"), cryptoObject, oneginiBiometricCallbackMock)
  }

}