package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.android.handlers.OneginiAuthenticationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiAuthenticationError
import com.onegini.mobile.sdk.android.model.OneginiAuthenticator
import com.onegini.mobile.sdk.android.model.entity.CustomInfo
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.pigeonPlugin.FlutterError
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWCustomInfo
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWRegistrationResponse
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWUserProfile
import com.onegini.mobile.sdk.flutter.useCases.AuthenticateUserUseCase
import com.onegini.mobile.sdk.flutter.useCases.GetUserProfileUseCase
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
class AuthenticateUserUseCaseTests {
  @Mock(answer = Answers.RETURNS_DEEP_STUBS)
  lateinit var oneginiSdk: OneginiSDK

  @Mock
  lateinit var callbackMock: (Result<OWRegistrationResponse>) -> Unit

  @Mock
  lateinit var oneginiAuthenticatorMock: OneginiAuthenticator

  @Mock
  lateinit var oneginiAuthenticationErrorMock: OneginiAuthenticationError

  lateinit var authenticateUserUseCase: AuthenticateUserUseCase

  @Before
  fun attach() {
    val getUserProfileUseCase = GetUserProfileUseCase(oneginiSdk)
    authenticateUserUseCase = AuthenticateUserUseCase(oneginiSdk, getUserProfileUseCase)
  }

  @Test
  fun `When the given authenticator id is null and a valid ProfileId is passed, Then it should call result success with UserProfile and CustomInfo as json`() {
    whenever(oneginiSdk.oneginiClient.userClient.userProfiles).thenReturn(setOf(UserProfile("QWERTY")))
    whenever(oneginiSdk.oneginiClient.userClient.authenticateUser(eq(UserProfile("QWERTY")), any())).thenAnswer {
      it.getArgument<OneginiAuthenticationHandler>(1).onSuccess(UserProfile("QWERTY"), CustomInfo(0, ""))
    }

    authenticateUserUseCase("QWERTY", null, callbackMock)

    argumentCaptor<Result<OWRegistrationResponse>>().apply {
      verify(callbackMock, times(1)).invoke(capture())
      val testUser = OWUserProfile("QWERTY")
      val testInfo = OWCustomInfo(0, "")
      Assert.assertEquals(firstValue.getOrNull(), OWRegistrationResponse(testUser, testInfo))
    }
  }

  @Test
  fun `When the requested UserProfileId is not registered, Then it should call result error`() {
    whenever(oneginiSdk.oneginiClient.userClient.userProfiles).thenReturn(emptySet())

    authenticateUserUseCase("QWERTY", null, callbackMock)

    argumentCaptor<Result<OWRegistrationResponse>>().apply {
      verify(callbackMock, times(1)).invoke(capture())

      when (val error = firstValue.exceptionOrNull()) {
        is FlutterError -> {
          Assert.assertEquals(error.code.toInt(), USER_PROFILE_DOES_NOT_EXIST.code)
          Assert.assertEquals(error.message, USER_PROFILE_DOES_NOT_EXIST.message)
        }
        else -> fail(UNEXPECTED_ERROR_TYPE.message)
      }
    }
  }

  @Test
  fun `When the given authenticator id is not found, Then it should return an error`() {
    whenever(oneginiSdk.oneginiClient.userClient.userProfiles).thenReturn(setOf(UserProfile("QWERTY")))
    whenever(oneginiSdk.oneginiClient.userClient.getRegisteredAuthenticators(eq(UserProfile("QWERTY")))).thenReturn(emptySet())

    authenticateUserUseCase("QWERTY", "TEST", callbackMock)

    argumentCaptor<Result<OWRegistrationResponse>>().apply {
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
  fun `When the given authenticator id is found and a valid ProfileId is passed, Then it should call result success with with UserProfile and CustomInfo as json`() {
    whenever(oneginiSdk.oneginiClient.userClient.userProfiles).thenReturn(setOf(UserProfile("QWERTY")))
    whenever(oneginiAuthenticatorMock.id).thenReturn("TEST")
    whenever(oneginiSdk.oneginiClient.userClient.getRegisteredAuthenticators(eq(UserProfile("QWERTY")))).thenReturn(
      setOf(
        oneginiAuthenticatorMock
      )
    )
    whenever(
      oneginiSdk.oneginiClient.userClient.authenticateUser(
        eq(UserProfile("QWERTY")),
        eq(oneginiAuthenticatorMock),
        any()
      )
    ).thenAnswer {
      it.getArgument<OneginiAuthenticationHandler>(2).onSuccess(UserProfile("QWERTY"), CustomInfo(0, ""))
    }

    authenticateUserUseCase("QWERTY", "TEST", callbackMock)

    argumentCaptor<Result<OWRegistrationResponse>>().apply {
      verify(callbackMock, times(1)).invoke(capture())
      val testUser = OWUserProfile("QWERTY")
      val testInfo = OWCustomInfo(0, "")
      Assert.assertEquals(firstValue.getOrNull(), OWRegistrationResponse(testUser, testInfo))
    }
  }

  @Test
  fun `When authenticateUser return error, Then it should call result error`() {
    whenever(oneginiSdk.oneginiClient.userClient.userProfiles).thenReturn(setOf(UserProfile("QWERTY")))
    whenever(oneginiAuthenticationErrorMock.errorType).thenReturn(OneginiAuthenticationError.GENERAL_ERROR)
    whenever(oneginiAuthenticationErrorMock.message).thenReturn("General error")
    whenever(oneginiSdk.oneginiClient.userClient.authenticateUser(eq(UserProfile("QWERTY")), any())).thenAnswer {
      it.getArgument<OneginiAuthenticationHandler>(1).onError(oneginiAuthenticationErrorMock)
    }

    authenticateUserUseCase("QWERTY", null, callbackMock)

    argumentCaptor<Result<OWRegistrationResponse>>().apply {
      verify(callbackMock, times(1)).invoke(capture())
      when (val error = firstValue.exceptionOrNull()) {
        is FlutterError -> {
          Assert.assertEquals(error.code.toInt(), oneginiAuthenticationErrorMock.errorType)
          Assert.assertEquals(error.message, oneginiAuthenticationErrorMock.message)
        }
        else -> fail(UNEXPECTED_ERROR_TYPE.message)
      }
    }
  }
}
