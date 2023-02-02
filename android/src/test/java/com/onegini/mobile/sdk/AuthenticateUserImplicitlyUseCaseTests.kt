package com.onegini.mobile.sdk

import com.google.common.truth.Truth
import com.google.gson.Gson
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
        whenever(callMock.argument<ArrayList<String>>("scope")).thenReturn(null)
        whenever(userClientMock.userProfiles).thenReturn(setOf(UserProfile("QWERTY")))
        whenever(oneginiImplicitTokenRequestErrorMock.errorType).thenReturn(OneginiImplicitTokenRequestError.GENERAL_ERROR)
        whenever(oneginiImplicitTokenRequestErrorMock.message).thenReturn("General error")
        whenever(userClientMock.authenticateUserImplicitly(eq(UserProfile("QWERTY")), isNull(), any())).thenAnswer {
            it.getArgument<OneginiImplicitAuthenticationHandler>(2).onError(oneginiImplicitTokenRequestErrorMock)
        }

        AuthenticateUserImplicitlyUseCase(clientMock)(callMock, resultSpy)

        verify(resultSpy).error(oneginiImplicitTokenRequestErrorMock.errorType.toString(), oneginiImplicitTokenRequestErrorMock.message, null)
    }

    @Test
    fun `should return error when there are no registered users`() {
        whenever(callMock.argument<ArrayList<String>>("scope")).thenReturn(null)
        whenever(userClientMock.userProfiles).thenReturn(setOf())

        AuthenticateUserImplicitlyUseCase(clientMock)(callMock, resultSpy)

        verify(resultSpy).error(USER_PROFILE_IS_NULL.code.toString(), USER_PROFILE_IS_NULL.message, null)
    }

    @Test
    fun `should return success when the SDK returns success`() {
        whenever(callMock.argument<ArrayList<String>>("scope")).thenReturn(arrayListOf("test"))
        whenever(userClientMock.userProfiles).thenReturn(setOf(UserProfile("QWERTY")))
        whenever(userClientMock.authenticateUserImplicitly(eq(UserProfile("QWERTY")), eq(arrayOf("test")), any())).thenAnswer {
            it.getArgument<OneginiImplicitAuthenticationHandler>(2).onSuccess(UserProfile("QWERTY"))
        }

        AuthenticateUserImplicitlyUseCase(clientMock)(callMock, resultSpy)

        verify(resultSpy).success(eq(Gson().toJson(UserProfile("QWERTY"))))
    }

    @Test
    fun `should scopes param be array of two scopes when given scopes contains two strings`() {
        whenever(callMock.argument<ArrayList<String>>("scope")).thenReturn(arrayListOf("read", "write"))
        whenever(userClientMock.userProfiles).thenReturn(setOf(UserProfile("QWERTY")))

        AuthenticateUserImplicitlyUseCase(clientMock)(callMock, resultSpy)

        argumentCaptor<Array<String>> {
            Mockito.verify(userClientMock).authenticateUserImplicitly(eq(UserProfile("QWERTY")), capture(), ArgumentMatchers.any())
            Truth.assertThat(firstValue.size).isEqualTo(2)
            Truth.assertThat(firstValue).isEqualTo(arrayOf("read", "write"))
        }
    }

}