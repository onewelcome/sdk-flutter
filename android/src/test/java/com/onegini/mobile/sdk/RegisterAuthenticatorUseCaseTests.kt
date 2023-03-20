package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.handlers.OneginiAuthenticatorRegistrationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiAuthenticatorRegistrationError
import com.onegini.mobile.sdk.android.model.OneginiAuthenticator
import com.onegini.mobile.sdk.android.model.entity.CustomInfo
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.SdkErrorAssert
import com.onegini.mobile.sdk.flutter.pigeonPlugin.FlutterError
import com.onegini.mobile.sdk.flutter.useCases.RegisterAuthenticatorUseCase
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
class RegisterAuthenticatorUseCaseTests {

  @Mock(answer = Answers.RETURNS_DEEP_STUBS)
  lateinit var oneginiSdk: OneginiSDK

  @Mock
  lateinit var clientMock: OneginiClient

  @Mock
  lateinit var oneginiAuthenticatorMock: OneginiAuthenticator

  @Mock
  lateinit var oneginiAuthenticatorRegistrationErrorMock: OneginiAuthenticatorRegistrationError

  @Mock
  lateinit var callbackMock: (Result<Unit>) -> Unit

  lateinit var registerAuthenticatorUseCase: RegisterAuthenticatorUseCase

  @Before
  fun attach() {
    registerAuthenticatorUseCase = RegisterAuthenticatorUseCase(oneginiSdk)
  }

  @Test
  fun `When no user is authenticated, Then it should return error`() {
    whenever(oneginiSdk.oneginiClient.userClient.authenticatedUserProfile).thenReturn(null)

    registerAuthenticatorUseCase("test", callbackMock)

    argumentCaptor<Result<Unit>>().apply {
      verify(callbackMock).invoke(capture())
      SdkErrorAssert.assertEquals(NO_USER_PROFILE_IS_AUTHENTICATED, firstValue.exceptionOrNull())
    }
  }

  @Test
  fun `When authenticator id is not recognised, Then it should return error`() {
    whenever(oneginiSdk.oneginiClient.userClient.authenticatedUserProfile).thenReturn(UserProfile("QWERTY"))
    whenever(oneginiSdk.oneginiClient.userClient.getAllAuthenticators(eq(UserProfile("QWERTY")))).thenReturn(setOf(oneginiAuthenticatorMock))
    whenever(oneginiAuthenticatorMock.id).thenReturn("other_test")

    registerAuthenticatorUseCase("test", callbackMock)

    argumentCaptor<Result<Unit>>().apply {
      verify(callbackMock).invoke(capture())
      SdkErrorAssert.assertEquals(AUTHENTICATOR_NOT_FOUND, firstValue.exceptionOrNull())
    }
  }

  @Test
  fun `When the user has an empty set of authenticators, Then an error should be returned`() {
    whenever(oneginiSdk.oneginiClient.userClient.authenticatedUserProfile).thenReturn(UserProfile("QWERTY"))
    whenever(oneginiSdk.oneginiClient.userClient.getAllAuthenticators(eq(UserProfile("QWERTY")))).thenReturn(emptySet())

    registerAuthenticatorUseCase("test", callbackMock)

    argumentCaptor<Result<Unit>>().apply {
      verify(callbackMock).invoke(capture())
      SdkErrorAssert.assertEquals(AUTHENTICATOR_NOT_FOUND, firstValue.exceptionOrNull())
    }
  }

  @Test
  fun `should return CustomInfo class with status and data as a params when given authenticator id found in getNotRegisteredAuthenticators method`() {
    whenever(oneginiSdk.oneginiClient.userClient.authenticatedUserProfile).thenReturn(UserProfile("QWERTY"))
    whenever(oneginiSdk.oneginiClient.userClient.getAllAuthenticators(eq(UserProfile("QWERTY")))).thenReturn(setOf(oneginiAuthenticatorMock))
    whenever(oneginiAuthenticatorMock.id).thenReturn("test")
    whenever(oneginiSdk.oneginiClient.userClient.registerAuthenticator(eq(oneginiAuthenticatorMock), any())).thenAnswer {
      it.getArgument<OneginiAuthenticatorRegistrationHandler>(1).onSuccess(CustomInfo(0, "data"))
    }

    registerAuthenticatorUseCase("test", callbackMock)

    argumentCaptor<Result<Unit>>().apply {
      verify(callbackMock).invoke(capture())
      Assert.assertEquals(firstValue.getOrNull(), Unit)
    }
  }

  @Test
  fun `should return error when registerAuthenticator method returns error`() {
    whenever(oneginiSdk.oneginiClient.userClient.authenticatedUserProfile).thenReturn(UserProfile("QWERTY"))
    whenever(oneginiSdk.oneginiClient.userClient.getAllAuthenticators(eq(UserProfile("QWERTY")))).thenReturn(setOf(oneginiAuthenticatorMock))
    whenever(oneginiAuthenticatorMock.id).thenReturn("test")
    whenever(oneginiAuthenticatorRegistrationErrorMock.errorType).thenReturn(OneginiAuthenticatorRegistrationError.GENERAL_ERROR)
    whenever(oneginiAuthenticatorRegistrationErrorMock.message).thenReturn("General error")
    whenever(oneginiSdk.oneginiClient.userClient.registerAuthenticator(eq(oneginiAuthenticatorMock), any())).thenAnswer {
      it.getArgument<OneginiAuthenticatorRegistrationHandler>(1).onError(oneginiAuthenticatorRegistrationErrorMock)
    }

    registerAuthenticatorUseCase("test", callbackMock)

    argumentCaptor<Result<Unit>>().apply {
      verify(callbackMock).invoke(capture())

      val expected = FlutterError(OneginiAuthenticatorRegistrationError.GENERAL_ERROR.toString(), "General error")
      SdkErrorAssert.assertEquals(expected, firstValue.exceptionOrNull())
    }
  }
}
