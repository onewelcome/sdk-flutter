package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.android.client.UserClient
import com.onegini.mobile.sdk.android.handlers.OneginiDeregisterUserProfileHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiDeregistrationError
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.useCases.DeregisterUserUseCase
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Answers
import org.mockito.Mock
import org.mockito.Spy
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.any
import org.mockito.kotlin.eq
import org.mockito.kotlin.verify
import org.mockito.kotlin.whenever

@RunWith(MockitoJUnitRunner::class)
class DeregisterUserUseCaseTests {

    @Mock(answer = Answers.RETURNS_DEEP_STUBS)
    lateinit var oneginiSdk: OneginiSDK
    
    @Mock
    lateinit var oneginiDeregistrationErrorMock: OneginiDeregistrationError

    @Mock
    lateinit var callMock: MethodCall

    @Spy
    lateinit var resultSpy: MethodChannel.Result

    lateinit var deregisterUserUseCase: DeregisterUserUseCase

    @Before
    fun attach() {
        deregisterUserUseCase = DeregisterUserUseCase(oneginiSdk)
    }

    @Test
    fun `should return error when user not authenticated`() {
        deregisterUserUseCase(callMock, resultSpy)

        val message = USER_PROFILE_DOES_NOT_EXIST.message
        verify(resultSpy).error(eq(USER_PROFILE_DOES_NOT_EXIST.code.toString()), eq(message), any())
    }

    @Test
    fun `should return true when user deregister`() {
        whenever(callMock.argument<String>("profileId")).thenReturn("QWERTY")
        whenever(oneginiSdk.oneginiClient.userClient.userProfiles).thenReturn(setOf(UserProfile("QWERTY")))

        whenever(oneginiSdk.oneginiClient.userClient.deregisterUser(eq(UserProfile("QWERTY")), any())).thenAnswer {
            it.getArgument<OneginiDeregisterUserProfileHandler>(1).onSuccess()
        }

        deregisterUserUseCase(callMock, resultSpy)

        verify(resultSpy).success(true)
    }

    @Test
    fun `should return error when deregister method return error`() {
        whenever(callMock.argument<String>("profileId")).thenReturn("QWERTY")
        whenever(oneginiSdk.oneginiClient.userClient.userProfiles).thenReturn(setOf(UserProfile("QWERTY")))
        whenever(oneginiSdk.oneginiClient.userClient.deregisterUser(eq(UserProfile("QWERTY")), any())).thenAnswer {
            it.getArgument<OneginiDeregisterUserProfileHandler>(1).onError(oneginiDeregistrationErrorMock)
        }
        whenever(oneginiDeregistrationErrorMock.errorType).thenReturn(OneginiDeregistrationError.GENERAL_ERROR)
        whenever(oneginiDeregistrationErrorMock.message).thenReturn("General error")

        deregisterUserUseCase(callMock, resultSpy)

        val message = oneginiDeregistrationErrorMock.message
        verify(resultSpy).error(eq(oneginiDeregistrationErrorMock.errorType.toString()), eq(message), any())
    }
}