package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.android.handlers.OneginiAuthenticatorDeregistrationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiAuthenticatorDeregistrationError
import com.onegini.mobile.sdk.android.model.OneginiAuthenticator
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.pigeonPlugin.FlutterError
import com.onegini.mobile.sdk.flutter.useCases.DeregisterAuthenticatorUseCase
import junit.framework.Assert.fail
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
import org.mockito.kotlin.times
import org.mockito.kotlin.verify
import org.mockito.kotlin.whenever

@RunWith(MockitoJUnitRunner::class)
class DeregisterAuthenticatorUseCaseTests {

  @Mock(answer = Answers.RETURNS_DEEP_STUBS)
  lateinit var oneginiSdk: OneginiSDK

  @Mock
  lateinit var oneginiAuthenticatorMock: OneginiAuthenticator

  @Mock
  lateinit var callbackMock: (Result<Unit>) -> Unit

  @Mock
  lateinit var oneginiAuthenticatorDeregistrationErrorMock: OneginiAuthenticatorDeregistrationError

  lateinit var deregisterAuthenticatorUseCase: DeregisterAuthenticatorUseCase

  @Before
  fun attach() {
    deregisterAuthenticatorUseCase = DeregisterAuthenticatorUseCase(oneginiSdk)
  }

  @Test
  fun `When no user is authenticated, Then it should return error`() {
    whenever(oneginiSdk.oneginiClient.userClient.authenticatedUserProfile).thenReturn(null)

    deregisterAuthenticatorUseCase("test", callbackMock)

    argumentCaptor<Result<Unit>>().apply {
      verify(callbackMock, times(1)).invoke(capture())
      when (val error = firstValue.exceptionOrNull()) {
        is FlutterError -> {
          Assert.assertEquals(error.code.toInt(), NO_USER_PROFILE_IS_AUTHENTICATED.code)
          Assert.assertEquals(error.message, NO_USER_PROFILE_IS_AUTHENTICATED.message)
        }
        else -> fail(UNEXPECTED_ERROR_TYPE.message)
      }
    }
  }

  @Test
  fun `When the given authenticator id is not found within the registered authenticators of the authenticated user, Then it should return an error`() {
    whenever(oneginiSdk.oneginiClient.userClient.authenticatedUserProfile).thenReturn(UserProfile("QWERTY"))
    whenever(oneginiSdk.oneginiClient.userClient.getRegisteredAuthenticators(eq(UserProfile("QWERTY")))).thenReturn(
      setOf(
        oneginiAuthenticatorMock
      )
    )
    whenever(oneginiAuthenticatorMock.id).thenReturn("other_test")

    deregisterAuthenticatorUseCase("test", callbackMock)

    argumentCaptor<Result<Unit>>().apply {
      verify(callbackMock, times(1)).invoke(capture())
      when (val error = firstValue.exceptionOrNull()) {
        is FlutterError -> {
          Assert.assertEquals(error.code.toInt(), AUTHENTICATOR_NOT_FOUND.code)
          Assert.assertEquals(error.message, AUTHENTICATOR_NOT_FOUND.message)
        }
        else -> fail(UNEXPECTED_ERROR_TYPE.message)
      }
    }
  }

  @Test
  fun `When getRegisteredAuthenticators method returns empty set, Then an error should be returned`() {
    whenever(oneginiSdk.oneginiClient.userClient.authenticatedUserProfile).thenReturn(UserProfile("QWERTY"))
    whenever(oneginiSdk.oneginiClient.userClient.getRegisteredAuthenticators(eq(UserProfile("QWERTY")))).thenReturn(emptySet())

    deregisterAuthenticatorUseCase("test", callbackMock)

    argumentCaptor<Result<Unit>>().apply {
      verify(callbackMock, times(1)).invoke(capture())
      when (val error = firstValue.exceptionOrNull()) {
        is FlutterError -> {
          Assert.assertEquals(error.code.toInt(), AUTHENTICATOR_NOT_FOUND.code)
          Assert.assertEquals(error.message, AUTHENTICATOR_NOT_FOUND.message)
        }
        else -> fail(UNEXPECTED_ERROR_TYPE.message)
      }
    }
  }

  @Test
  fun `When getRegisteredAuthenticators finds an authenticator for a authenticated user, Then it should return true`() {
    whenever(oneginiSdk.oneginiClient.userClient.authenticatedUserProfile).thenReturn(UserProfile("QWERTY"))
    whenever(oneginiSdk.oneginiClient.userClient.getRegisteredAuthenticators(eq(UserProfile("QWERTY")))).thenReturn(
      setOf(
        oneginiAuthenticatorMock
      )
    )
    whenever(oneginiAuthenticatorMock.id).thenReturn("test")
    whenever(oneginiSdk.oneginiClient.userClient.deregisterAuthenticator(eq(oneginiAuthenticatorMock), any())).thenAnswer {
      it.getArgument<OneginiAuthenticatorDeregistrationHandler>(1).onSuccess()
    }

    deregisterAuthenticatorUseCase("test", callbackMock)

    argumentCaptor<Result<Unit>>().apply {
      verify(callbackMock, times(1)).invoke(capture())
      Assert.assertEquals(firstValue.getOrNull(), Unit)
    }
  }

  @Test
  fun `When deregisterAuthenticator method returns error, Then the function should return an error`() {
    whenever(oneginiSdk.oneginiClient.userClient.authenticatedUserProfile).thenReturn(UserProfile("QWERTY"))
    whenever(oneginiSdk.oneginiClient.userClient.getRegisteredAuthenticators(eq(UserProfile("QWERTY")))).thenReturn(
      setOf(
        oneginiAuthenticatorMock
      )
    )
    whenever(oneginiAuthenticatorMock.id).thenReturn("test")
    whenever(oneginiAuthenticatorDeregistrationErrorMock.errorType).thenReturn(OneginiAuthenticatorDeregistrationError.GENERAL_ERROR)
    whenever(oneginiAuthenticatorDeregistrationErrorMock.message).thenReturn("General error")
    whenever(oneginiSdk.oneginiClient.userClient.deregisterAuthenticator(eq(oneginiAuthenticatorMock), any())).thenAnswer {
      it.getArgument<OneginiAuthenticatorDeregistrationHandler>(1).onError(oneginiAuthenticatorDeregistrationErrorMock)
    }

    deregisterAuthenticatorUseCase("test", callbackMock)

    argumentCaptor<Result<Unit>>().apply {
      verify(callbackMock, times(1)).invoke(capture())
      when (val error = firstValue.exceptionOrNull()) {
        is FlutterError -> {
          Assert.assertEquals(error.code.toInt(), oneginiAuthenticatorDeregistrationErrorMock.errorType)
          Assert.assertEquals(error.message, oneginiAuthenticatorDeregistrationErrorMock.message)
        }
        else -> fail(UNEXPECTED_ERROR_TYPE.message)
      }
    }
  }
}
