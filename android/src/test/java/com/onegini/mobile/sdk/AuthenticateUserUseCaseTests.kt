package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.android.handlers.OneginiAuthenticationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiAuthenticationError
import com.onegini.mobile.sdk.android.model.OneginiAuthenticator
import com.onegini.mobile.sdk.android.model.entity.CustomInfo
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.SdkErrorAssert
import com.onegini.mobile.sdk.flutter.pigeonPlugin.FlutterError
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWAuthenticatorType
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWCustomInfo
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWRegistrationResponse
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWUserProfile
import com.onegini.mobile.sdk.flutter.useCases.AuthenticateUserUseCase
import com.onegini.mobile.sdk.flutter.useCases.GetUserProfileUseCase
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Answers
import org.mockito.Mock
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.any
import org.mockito.kotlin.anyOrNull
import org.mockito.kotlin.argumentCaptor
import org.mockito.kotlin.eq
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

  private lateinit var authenticateUserUseCase: AuthenticateUserUseCase

  private val profileId = "QWERTY"

  @Before
  fun attach() {
    val getUserProfileUseCase = GetUserProfileUseCase(oneginiSdk)
    authenticateUserUseCase = AuthenticateUserUseCase(oneginiSdk, getUserProfileUseCase)
  }

  @Test
  fun `When the requested UserProfileId is not registered, Then it should call result error`() {
    whenever(oneginiSdk.oneginiClient.userClient.userProfiles).thenReturn(emptySet())

    authenticateUserUseCase("QWERTY", null, callbackMock)

    argumentCaptor<Result<OWRegistrationResponse>>().apply {
      verify(callbackMock).invoke(capture())

      SdkErrorAssert.assertEquals(USER_PROFILE_DOES_NOT_EXIST, firstValue.exceptionOrNull())
    }
  }

  @Test
  fun `When a valid ProfileId is passed and null for authenticatorType, Then it should call result success with with UserProfile and CustomInfo as json`() {
    whenUserProfileExists()
    whenever(
      oneginiSdk.oneginiClient.userClient.authenticateUser(
        anyOrNull(),
        anyOrNull()
      )
    ).thenAnswer {
      it.getArgument<OneginiAuthenticationHandler>(1).onSuccess(UserProfile("QWERTY"), CustomInfo(0, ""))
    }

    authenticateUserUseCase("QWERTY", null, callbackMock)

    argumentCaptor<Result<OWRegistrationResponse>>().apply {
      verify(callbackMock).invoke(capture())
      val testUser = OWUserProfile("QWERTY")
      val testInfo = OWCustomInfo(0, "")
      Assert.assertEquals(firstValue.getOrNull(), OWRegistrationResponse(testUser, testInfo))
    }
  }

  @Test
  fun `When a valid ProfileId is passed with a non-null authenticatorType which is registered, Then it should call result success with with UserProfile and CustomInfo as json`() {
    whenUserProfileExists()
    whenFingerprintIsRegistered()
    whenever(
      oneginiSdk.oneginiClient.userClient.authenticateUser(
        anyOrNull(),
        anyOrNull(),
        anyOrNull()
      )
    ).thenAnswer {
      it.getArgument<OneginiAuthenticationHandler>(2).onSuccess(UserProfile("QWERTY"), CustomInfo(0, ""))
    }

    authenticateUserUseCase("QWERTY", OWAuthenticatorType.BIOMETRIC, callbackMock)

    argumentCaptor<Result<OWRegistrationResponse>>().apply {
      verify(callbackMock).invoke(capture())
      val testUser = OWUserProfile("QWERTY")
      val testInfo = OWCustomInfo(0, "")
      Assert.assertEquals(firstValue.getOrNull(), OWRegistrationResponse(testUser, testInfo))
    }
  }

  @Test
  fun `When authenticateUser return error, Then it should call result error`() {
    whenUserProfileExists()
    whenever(oneginiAuthenticationErrorMock.errorType).thenReturn(OneginiAuthenticationError.GENERAL_ERROR)
    whenever(oneginiAuthenticationErrorMock.message).thenReturn("General error")
    whenever(oneginiSdk.oneginiClient.userClient.authenticateUser(eq(UserProfile(profileId)), any())).thenAnswer {
      it.getArgument<OneginiAuthenticationHandler>(1).onError(oneginiAuthenticationErrorMock)
    }

    authenticateUserUseCase("QWERTY", null, callbackMock)

    argumentCaptor<Result<OWRegistrationResponse>>().apply {
      verify(callbackMock).invoke(capture())

      val expected = FlutterError(oneginiAuthenticationErrorMock.errorType.toString(), oneginiAuthenticationErrorMock.message)
      SdkErrorAssert.assertEquals(expected, firstValue.exceptionOrNull())
    }
  }

  private fun whenUserProfileExists() {
    whenever(oneginiSdk.oneginiClient.userClient.userProfiles).thenReturn(setOf(UserProfile(profileId)))
  }

  private fun whenFingerprintIsRegistered() {
    whenever(oneginiAuthenticatorMock.type).thenReturn(OneginiAuthenticator.FINGERPRINT)
    whenever(oneginiSdk.oneginiClient.userClient.getRegisteredAuthenticators(eq(UserProfile("QWERTY")))).thenReturn(
      setOf(
        oneginiAuthenticatorMock
      )
    )
  }

}
