package com.onegini.mobile.sdk

import com.google.common.truth.Truth
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.client.UserClient
import com.onegini.mobile.sdk.android.handlers.OneginiImplicitAuthenticationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiImplicitTokenRequestError
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.useCases.AuthenticateUserImplicitlyUseCase
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.ArgumentMatchers
import org.mockito.Mock
import org.mockito.Mockito
import org.mockito.Spy
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.any
import org.mockito.kotlin.isNull
import org.mockito.kotlin.verify
import org.mockito.kotlin.whenever
import org.mockito.kotlin.eq
import org.mockito.kotlin.argumentCaptor

@RunWith(MockitoJUnitRunner::class)
class AuthenticateUserImplicitlyUseCaseTests {

  @Mock
  lateinit var clientMock: OneginiClient

  @Mock
  lateinit var oneginiImplicitTokenRequestErrorMock: OneginiImplicitTokenRequestError

  @Mock
  lateinit var userClientMock: UserClient

  @Mock
  lateinit var callMock: MethodCall

  @Spy
  lateinit var resultSpy: MethodChannel.Result

  @Before
  fun attach() {
    whenever(clientMock.userClient).thenReturn(userClientMock)
  }

  @Test
  fun `should return error when the sdk returns authentication error`() {
    whenever(callMock.argument<ArrayList<String>>("scopes")).thenReturn(null)
    whenever(callMock.argument<String>("profileId")).thenReturn("QWERTY")

    whenever(userClientMock.userProfiles).thenReturn(setOf(UserProfile("QWERTY")))

    whenever(oneginiImplicitTokenRequestErrorMock.errorType).thenReturn(GENERIC_ERROR.code)
    whenever(oneginiImplicitTokenRequestErrorMock.message).thenReturn(GENERIC_ERROR.message)
    whenever(userClientMock.authenticateUserImplicitly(eq(UserProfile("QWERTY")), isNull(), any())).thenAnswer {
      it.getArgument<OneginiImplicitAuthenticationHandler>(2).onError(oneginiImplicitTokenRequestErrorMock)
    }

    AuthenticateUserImplicitlyUseCase(clientMock)(callMock, resultSpy)

    verify(resultSpy).error(
      GENERIC_ERROR.code.toString(), GENERIC_ERROR.message,
      mutableMapOf("code" to GENERIC_ERROR.code.toString(), "message" to GENERIC_ERROR.message)
    )
  }

  @Test
  fun `should return error when the userProfileId is not a registered users`() {
    whenever(callMock.argument<ArrayList<String>>("scopes")).thenReturn(null)
    whenever(callMock.argument<String>("profileId")).thenReturn("QWERTY")
    whenever(userClientMock.userProfiles).thenReturn(setOf())

    AuthenticateUserImplicitlyUseCase(clientMock)(callMock, resultSpy)

    verify(resultSpy).error(
      USER_PROFILE_DOES_NOT_EXIST.code.toString(), USER_PROFILE_DOES_NOT_EXIST.message,
      mutableMapOf("code" to USER_PROFILE_DOES_NOT_EXIST.code.toString(), "message" to USER_PROFILE_DOES_NOT_EXIST.message)
    )
  }

  @Test
  fun `should return success when the SDK returns success`() {
    whenever(callMock.argument<ArrayList<String>>("scopes")).thenReturn(arrayListOf("test"))
    whenever(callMock.argument<String>("profileId")).thenReturn("QWERTY")

    whenever(userClientMock.userProfiles).thenReturn(setOf(UserProfile("QWERTY")))
    whenever(userClientMock.authenticateUserImplicitly(eq(UserProfile("QWERTY")), eq(arrayOf("test")), any())).thenAnswer {
      it.getArgument<OneginiImplicitAuthenticationHandler>(2).onSuccess(UserProfile("QWERTY"))
    }

    AuthenticateUserImplicitlyUseCase(clientMock)(callMock, resultSpy)

    verify(resultSpy).success(eq("QWERTY"))
  }

  @Test
  fun `should scopes param be array of two scopes when given scopes contains two strings`() {
    whenever(callMock.argument<ArrayList<String>>("scopes")).thenReturn(arrayListOf("read", "write"))
    whenever(callMock.argument<String>("profileId")).thenReturn("QWERTY")

    whenever(userClientMock.userProfiles).thenReturn(setOf(UserProfile("QWERTY")))

    AuthenticateUserImplicitlyUseCase(clientMock)(callMock, resultSpy)

    argumentCaptor<Array<String>> {
      verify(userClientMock).authenticateUserImplicitly(eq(UserProfile("QWERTY")), capture(), ArgumentMatchers.any())
      Truth.assertThat(firstValue.size).isEqualTo(2)
      Truth.assertThat(firstValue).isEqualTo(arrayOf("read", "write"))
    }
  }
}
