package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.android.handlers.OneginiAuthenticatorDeregistrationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiAuthenticatorDeregistrationError
import com.onegini.mobile.sdk.android.model.OneginiAuthenticator
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.SdkErrorAssert
import com.onegini.mobile.sdk.flutter.pigeonPlugin.FlutterError
import com.onegini.mobile.sdk.flutter.useCases.DeregisterBiometricAuthenticatorUseCase
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
class DeregisterBiometricAuthenticatorUseCaseTests {
  @Mock(answer = Answers.RETURNS_DEEP_STUBS)
  lateinit var oneginiSdk: OneginiSDK

  @Mock
  lateinit var oneginiAuthenticatorMock: OneginiAuthenticator

  @Mock
  lateinit var callbackMock: (Result<Unit>) -> Unit

  @Mock
  lateinit var oneginiAuthenticatorDeregistrationErrorMock: OneginiAuthenticatorDeregistrationError

  private lateinit var deregisterBiometricAuthenticatorUseCase: DeregisterBiometricAuthenticatorUseCase

  @Before
  fun attach() {
    deregisterBiometricAuthenticatorUseCase = DeregisterBiometricAuthenticatorUseCase(oneginiSdk)
  }

  @Test
  fun `When no user is authenticated, Then it should return error`() {
    whenever(oneginiSdk.oneginiClient.userClient.authenticatedUserProfile).thenReturn(null)

    deregisterBiometricAuthenticatorUseCase(callbackMock)

    argumentCaptor<Result<Unit>>().apply {
      verify(callbackMock).invoke(capture())
      SdkErrorAssert.assertEquals(NOT_AUTHENTICATED_USER, firstValue.exceptionOrNull())
    }
  }

  @Test
  fun `When the given Biometric authenticator is not available, Then it should return an BIOMETRIC_AUTHENTICATION_NOT_AVAILABLE error`() {
    whenever(oneginiSdk.oneginiClient.userClient.authenticatedUserProfile).thenReturn(UserProfile("QWERTY"))
    whenever(oneginiSdk.oneginiClient.userClient.getAllAuthenticators(eq(UserProfile("QWERTY")))).thenReturn(
      setOf(oneginiAuthenticatorMock)
    )
    whenever(oneginiAuthenticatorMock.type).thenReturn(OneginiAuthenticator.PIN)

    deregisterBiometricAuthenticatorUseCase(callbackMock)

    argumentCaptor<Result<Unit>>().apply {
      verify(callbackMock).invoke(capture())
      SdkErrorAssert.assertEquals(BIOMETRIC_AUTHENTICATION_NOT_AVAILABLE, firstValue.exceptionOrNull())
    }
  }

  @Test
  fun `When biometric authenticator exists for the authenticated user, Then it should return call userClient_deregisterAuthenticator`() {
    whenever(oneginiSdk.oneginiClient.userClient.authenticatedUserProfile).thenReturn(UserProfile("QWERTY"))
    whenever(oneginiSdk.oneginiClient.userClient.getAllAuthenticators(eq(UserProfile("QWERTY")))).thenReturn(
      setOf(oneginiAuthenticatorMock)
    )
    whenever(oneginiAuthenticatorMock.type).thenReturn(OneginiAuthenticator.FINGERPRINT)

    deregisterBiometricAuthenticatorUseCase(callbackMock)

    verify(oneginiSdk.oneginiClient.userClient).deregisterAuthenticator(any(), any())
  }

  @Test
  fun `When deregisterAuthenticator calls onSuccess, Then it should resolve`() {
    whenever(oneginiSdk.oneginiClient.userClient.authenticatedUserProfile).thenReturn(UserProfile("QWERTY"))
    whenever(oneginiSdk.oneginiClient.userClient.getAllAuthenticators(eq(UserProfile("QWERTY")))).thenReturn(
      setOf(oneginiAuthenticatorMock)
    )
    whenever(oneginiAuthenticatorMock.type).thenReturn(OneginiAuthenticator.FINGERPRINT)
    whenever(oneginiSdk.oneginiClient.userClient.deregisterAuthenticator(eq(oneginiAuthenticatorMock), any())).thenAnswer {
      it.getArgument<OneginiAuthenticatorDeregistrationHandler>(1).onSuccess()
    }

    deregisterBiometricAuthenticatorUseCase(callbackMock)

    argumentCaptor<Result<Unit>>().apply {
      verify(callbackMock).invoke(capture())
      Assert.assertEquals(firstValue.getOrNull(), Unit)
    }
  }

  @Test
  fun `When deregisterAuthenticator method returns error, Then the function should return an error`() {
    whenever(oneginiSdk.oneginiClient.userClient.authenticatedUserProfile).thenReturn(UserProfile("QWERTY"))
    whenever(oneginiSdk.oneginiClient.userClient.getAllAuthenticators(eq(UserProfile("QWERTY")))).thenReturn(
      setOf(oneginiAuthenticatorMock)
    )
    whenever(oneginiAuthenticatorMock.type).thenReturn(OneginiAuthenticator.FINGERPRINT)
    whenever(oneginiAuthenticatorDeregistrationErrorMock.errorType).thenReturn(OneginiAuthenticatorDeregistrationError.GENERAL_ERROR)
    whenever(oneginiAuthenticatorDeregistrationErrorMock.message).thenReturn("General error")
    whenever(oneginiSdk.oneginiClient.userClient.deregisterAuthenticator(eq(oneginiAuthenticatorMock), any())).thenAnswer {
      it.getArgument<OneginiAuthenticatorDeregistrationHandler>(1).onError(oneginiAuthenticatorDeregistrationErrorMock)
    }

    deregisterBiometricAuthenticatorUseCase(callbackMock)

    argumentCaptor<Result<Unit>>().apply {
      verify(callbackMock).invoke(capture())
      val expected = FlutterError(oneginiAuthenticatorDeregistrationErrorMock.errorType.toString(), oneginiAuthenticatorDeregistrationErrorMock.message)
      SdkErrorAssert.assertEquals(expected, firstValue.exceptionOrNull())
    }
  }
}
