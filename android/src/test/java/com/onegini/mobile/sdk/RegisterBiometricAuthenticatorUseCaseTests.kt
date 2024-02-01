package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.android.handlers.OneginiAuthenticatorRegistrationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiAuthenticatorRegistrationError
import com.onegini.mobile.sdk.android.model.OneginiAuthenticator
import com.onegini.mobile.sdk.android.model.entity.CustomInfo
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.SdkErrorAssert
import com.onegini.mobile.sdk.flutter.pigeonPlugin.FlutterError
import com.onegini.mobile.sdk.flutter.useCases.RegisterBiometricAuthenticatorUseCase
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Answers
import org.mockito.Mock
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.any
import org.mockito.kotlin.argumentCaptor
import org.mockito.kotlin.eq
import org.mockito.kotlin.verify
import org.mockito.kotlin.whenever

@RunWith(MockitoJUnitRunner::class)
class RegisterBiometricAuthenticatorUseCaseTests {
  @Mock(answer = Answers.RETURNS_DEEP_STUBS)
  lateinit var oneginiSdk: OneginiSDK

  @Mock
  lateinit var oneginiAuthenticatorMock: OneginiAuthenticator

  @Mock
  lateinit var oneginiAuthenticatorRegistrationErrorMock: OneginiAuthenticatorRegistrationError

  @Mock
  lateinit var callbackMock: (Result<Unit>) -> Unit

  private lateinit var registerBiometricAuthenticatorUseCase: RegisterBiometricAuthenticatorUseCase

  @Before
  fun attach() {
    registerBiometricAuthenticatorUseCase = RegisterBiometricAuthenticatorUseCase(oneginiSdk)
  }

  @Test
  fun `When no user is authenticated, Then it should return error`() {
    whenever(oneginiSdk.oneginiClient.userClient.authenticatedUserProfile).thenReturn(null)

    registerBiometricAuthenticatorUseCase(callbackMock)

    argumentCaptor<Result<Unit>>().apply {
      verify(callbackMock).invoke(capture())
      SdkErrorAssert.assertEquals(NOT_AUTHENTICATED_USER, firstValue.exceptionOrNull())
    }
  }

  @Test
  fun `When authenticatorType is biometric and this is not available, Then it should return error`() {
    whenever(oneginiSdk.oneginiClient.userClient.authenticatedUserProfile).thenReturn(UserProfile("QWERTY"))
    whenever(oneginiSdk.oneginiClient.userClient.getAllAuthenticators(eq(UserProfile("QWERTY")))).thenReturn(setOf(oneginiAuthenticatorMock))
    // We have PIN, but not FINGERPRINT
    whenever(oneginiAuthenticatorMock.type).thenReturn(OneginiAuthenticator.PIN)

    registerBiometricAuthenticatorUseCase(callbackMock)

    argumentCaptor<Result<Unit>>().apply {
      verify(callbackMock).invoke(capture())
      SdkErrorAssert.assertEquals(BIOMETRIC_AUTHENTICATION_NOT_AVAILABLE, firstValue.exceptionOrNull())
    }
  }

  @Test
  fun `When the authenticator is successfully registered, Then should resolve`() {
    whenever(oneginiSdk.oneginiClient.userClient.authenticatedUserProfile).thenReturn(UserProfile("QWERTY"))
    whenever(oneginiSdk.oneginiClient.userClient.getAllAuthenticators(eq(UserProfile("QWERTY")))).thenReturn(setOf(oneginiAuthenticatorMock))
    whenever(oneginiAuthenticatorMock.type).thenReturn(OneginiAuthenticator.BIOMETRIC)
    whenever(oneginiSdk.oneginiClient.userClient.registerAuthenticator(eq(oneginiAuthenticatorMock), any())).thenAnswer {
      it.getArgument<OneginiAuthenticatorRegistrationHandler>(1).onSuccess(CustomInfo(0, "data"))
    }

    registerBiometricAuthenticatorUseCase(callbackMock)

    argumentCaptor<Result<Unit>>().apply {
      verify(callbackMock).invoke(capture())
      Assert.assertEquals(firstValue.getOrNull(), Unit)
    }
  }

  @Test
  fun `When registerAuthenticator calls onError, Then should reject with that error`() {
    whenever(oneginiSdk.oneginiClient.userClient.authenticatedUserProfile).thenReturn(UserProfile("QWERTY"))
    whenever(oneginiSdk.oneginiClient.userClient.getAllAuthenticators(eq(UserProfile("QWERTY")))).thenReturn(setOf(oneginiAuthenticatorMock))
    whenever(oneginiAuthenticatorMock.type).thenReturn(OneginiAuthenticator.BIOMETRIC)
    whenever(oneginiAuthenticatorRegistrationErrorMock.errorType).thenReturn(OneginiAuthenticatorRegistrationError.GENERAL_ERROR)
    whenever(oneginiAuthenticatorRegistrationErrorMock.message).thenReturn("General error")
    whenever(oneginiSdk.oneginiClient.userClient.registerAuthenticator(eq(oneginiAuthenticatorMock), any())).thenAnswer {
      it.getArgument<OneginiAuthenticatorRegistrationHandler>(1).onError(oneginiAuthenticatorRegistrationErrorMock)
    }

    registerBiometricAuthenticatorUseCase(callbackMock)

    argumentCaptor<Result<Unit>>().apply {
      verify(callbackMock).invoke(capture())

      val expected = FlutterError(OneginiAuthenticatorRegistrationError.GENERAL_ERROR.toString(), "General error")
      SdkErrorAssert.assertEquals(expected, firstValue.exceptionOrNull())
    }
  }
}
