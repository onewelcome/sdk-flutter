package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.handlers.OneginiLogoutHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiLogoutError
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.useCases.LogoutUseCase
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
class LogoutUseCaseTests {

    @Mock(answer = Answers.RETURNS_DEEP_STUBS)
    lateinit var oneginiSdk: OneginiSDK

    @Mock
    lateinit var clientMock: OneginiClient
    @Mock
    lateinit var oneginiLogoutError: OneginiLogoutError

    @Spy
    lateinit var resultSpy: MethodChannel.Result

    lateinit var logoutUseCase: LogoutUseCase
    @Before
    fun attach() {
        logoutUseCase = LogoutUseCase(oneginiSdk)
    }

    @Test
    fun `should return true when SDK return success`() {
        whenever(oneginiSdk.oneginiClient.userClient.logout(any())).thenAnswer {
            it.getArgument<OneginiLogoutHandler>(0).onSuccess()
        }

        logoutUseCase(resultSpy)

        verify(resultSpy).success(true)
    }

    @Test
    fun `should return error when SDK return error`() {
        whenever(oneginiLogoutError.errorType).thenReturn(OneginiLogoutError.GENERAL_ERROR)
        whenever(oneginiLogoutError.message).thenReturn("General error")
        whenever(oneginiSdk.oneginiClient.userClient.logout(any())).thenAnswer {
            it.getArgument<OneginiLogoutHandler>(0).onError(oneginiLogoutError)
        }

        logoutUseCase(resultSpy)

        val message = oneginiLogoutError.message
        verify(resultSpy).error(eq(oneginiLogoutError.errorType.toString()), eq(message), any())
    }
}