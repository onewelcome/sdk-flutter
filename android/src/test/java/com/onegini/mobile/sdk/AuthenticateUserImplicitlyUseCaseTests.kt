package com.onegini.mobile.sdk

import com.google.common.truth.Truth
import com.onegini.mobile.sdk.android.handlers.OneginiImplicitAuthenticationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiImplicitTokenRequestError
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.SdkErrorAssert
import com.onegini.mobile.sdk.flutter.pigeonPlugin.FlutterError
import com.onegini.mobile.sdk.flutter.useCases.AuthenticateUserImplicitlyUseCase
import com.onegini.mobile.sdk.flutter.useCases.GetUserProfileUseCase
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Answers
import org.mockito.ArgumentMatchers
import org.mockito.Mock
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.any
import org.mockito.kotlin.argumentCaptor
import org.mockito.kotlin.eq
import org.mockito.kotlin.isNull
import org.mockito.kotlin.verify
import org.mockito.kotlin.whenever

@RunWith(MockitoJUnitRunner::class)
class AuthenticateUserImplicitlyUseCaseTests {

  @Mock(answer = Answers.RETURNS_DEEP_STUBS)
  lateinit var oneginiSdk: OneginiSDK

  @Mock
  lateinit var oneginiImplicitTokenRequestErrorMock: OneginiImplicitTokenRequestError

  @Mock
  lateinit var callbackMock: (Result<Unit>) -> Unit

  private lateinit var authenticateUserImplicitlyUseCase: AuthenticateUserImplicitlyUseCase

  @Before
  fun attach() {
    val getUserProfileUseCase = GetUserProfileUseCase(oneginiSdk)
    authenticateUserImplicitlyUseCase = AuthenticateUserImplicitlyUseCase(oneginiSdk, getUserProfileUseCase)
  }

  @Test
  fun `should return error when the sdk returns authentication error`() {
    whenever(oneginiSdk.oneginiClient.userClient.userProfiles).thenReturn(setOf(UserProfile("QWERTY")))

    whenever(oneginiImplicitTokenRequestErrorMock.errorType).thenReturn(GENERIC_ERROR.code)
    whenever(oneginiImplicitTokenRequestErrorMock.message).thenReturn(GENERIC_ERROR.message)
    whenever(oneginiSdk.oneginiClient.userClient.authenticateUserImplicitly(eq(UserProfile("QWERTY")), isNull(), any())).thenAnswer {
      it.getArgument<OneginiImplicitAuthenticationHandler>(2).onError(oneginiImplicitTokenRequestErrorMock)
    }

    authenticateUserImplicitlyUseCase("QWERTY", null, callbackMock)

    argumentCaptor<Result<Unit>>().apply {
      verify(callbackMock).invoke(capture())

      val expected = FlutterError(GENERIC_ERROR.code.toString(), GENERIC_ERROR.message)

      SdkErrorAssert.assertEquals(expected, firstValue.exceptionOrNull())
    }
  }

  @Test
  fun `When the userProfileId is not a registered users, Then an error should be returned`() {
    whenever(oneginiSdk.oneginiClient.userClient.userProfiles).thenReturn(setOf())

    authenticateUserImplicitlyUseCase("QWERTY", null, callbackMock)

    argumentCaptor<Result<Unit>>().apply {
      verify(callbackMock).invoke(capture())

      SdkErrorAssert.assertEquals(DOES_NOT_EXIST_USER_PROFILE, firstValue.exceptionOrNull())
    }
  }

  @Test
  fun `When the implicit authentications goes successfully, Then the function should resolve with success`() {
    whenever(oneginiSdk.oneginiClient.userClient.userProfiles).thenReturn(setOf(UserProfile("QWERTY")))
    whenever(
      oneginiSdk.oneginiClient.userClient.authenticateUserImplicitly(
        eq(UserProfile("QWERTY")),
        eq(arrayOf("test")),
        any()
      )
    ).thenAnswer {
      it.getArgument<OneginiImplicitAuthenticationHandler>(2).onSuccess(UserProfile("QWERTY"))
    }

    authenticateUserImplicitlyUseCase("QWERTY", listOf("test"), callbackMock)

    argumentCaptor<Result<Unit>>().apply {
      verify(callbackMock).invoke(capture())
      Assert.assertEquals(firstValue.getOrNull(), Unit)
    }
  }

  @Test
  fun `When given scopes contains two strings, Then scopes param should be array of two scopes`() {
    whenever(oneginiSdk.oneginiClient.userClient.userProfiles).thenReturn(setOf(UserProfile("QWERTY")))

    authenticateUserImplicitlyUseCase("QWERTY", listOf("read", "write"), callbackMock)

    argumentCaptor<Array<String>> {
      verify(oneginiSdk.oneginiClient.userClient).authenticateUserImplicitly(eq(UserProfile("QWERTY")), capture(), ArgumentMatchers.any())
      Truth.assertThat(firstValue.size).isEqualTo(2)
      Truth.assertThat(firstValue).isEqualTo(arrayOf("read", "write"))
    }
  }
}
