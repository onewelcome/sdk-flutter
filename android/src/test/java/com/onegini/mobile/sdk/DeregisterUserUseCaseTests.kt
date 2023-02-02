package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.client.UserClient
import com.onegini.mobile.sdk.android.handlers.OneginiDeregisterUserProfileHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiDeregistrationError
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.useCases.DeregisterUserUseCase
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Mock
import org.mockito.Spy
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.any
import org.mockito.kotlin.eq
import org.mockito.kotlin.verify
import org.mockito.kotlin.whenever

@RunWith(MockitoJUnitRunner::class)
class DeregisterUserUseCaseTests {

    @Mock
    lateinit var clientMock: OneginiClient

    @Mock
    lateinit var userClientMock: UserClient

    @Mock
    lateinit var oneginiDeregistrationErrorMock: OneginiDeregistrationError

    @Mock
    lateinit var callMock: MethodCall

    @Spy
    lateinit var resultSpy: MethodChannel.Result

    @Before
    fun attach() {
        whenever(clientMock.userClient).thenReturn(userClientMock)
    }

    @Test
    fun `should return error when user not authenticated`() {
        DeregisterUserUseCase(clientMock)(callMock, resultSpy)

        verify(resultSpy).error(USER_PROFILE_IS_NULL.code.toString(), USER_PROFILE_IS_NULL.message, null)
    }

    @Test
    fun `should return true when user deregister`() {
        whenever(callMock.argument<String>("profileId")).thenReturn("QWERTY")
        whenever(userClientMock.userProfiles).thenReturn(setOf(UserProfile("QWERTY")))

        whenever(userClientMock.deregisterUser(eq(UserProfile("QWERTY")), any())).thenAnswer {
            it.getArgument<OneginiDeregisterUserProfileHandler>(1).onSuccess()
        }

        DeregisterUserUseCase(clientMock)(callMock, resultSpy)

        verify(resultSpy).success(true)
    }

    @Test
    fun `should return error when deregister method return error`() {
        whenever(callMock.argument<String>("profileId")).thenReturn("QWERTY")
        whenever(userClientMock.userProfiles).thenReturn(setOf(UserProfile("QWERTY")))
        whenever(userClientMock.deregisterUser(eq(UserProfile("QWERTY")), any())).thenAnswer {
            it.getArgument<OneginiDeregisterUserProfileHandler>(1).onError(oneginiDeregistrationErrorMock)
        }
        whenever(oneginiDeregistrationErrorMock.errorType).thenReturn(OneginiDeregistrationError.GENERAL_ERROR)
        whenever(oneginiDeregistrationErrorMock.message).thenReturn("General error")

        DeregisterUserUseCase(clientMock)(callMock, resultSpy)

        verify(resultSpy).error(oneginiDeregistrationErrorMock.errorType.toString(), oneginiDeregistrationErrorMock.message, null)
    }
}