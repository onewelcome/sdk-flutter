package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.client.UserClient
import com.onegini.mobile.sdk.android.handlers.OneginiChangePinHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiChangePinError
import com.onegini.mobile.sdk.flutter.useCases.ChangePinUseCase
import io.flutter.plugin.common.MethodChannel
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Mock
import org.mockito.Spy
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.any
import org.mockito.kotlin.verify
import org.mockito.kotlin.whenever

@RunWith(MockitoJUnitRunner::class)
class ChangePinUseCaseTests {
    @Mock
    lateinit var clientMock: OneginiClient

    @Mock
    lateinit var userClientMock: UserClient

    @Mock
    lateinit var oneginiChangePinError: OneginiChangePinError

    @Spy
    lateinit var resultSpy: MethodChannel.Result

    @Before
    fun attach() {
        whenever(clientMock.userClient).thenReturn(userClientMock)
    }

    @Test
    fun `should return error when sdk return error`() {
        whenever(oneginiChangePinError.errorType).thenReturn(OneginiChangePinError.GENERAL_ERROR)
        whenever(oneginiChangePinError.message).thenReturn("General error")
        whenever(userClientMock.changePin(any())).thenAnswer {
            it.getArgument<OneginiChangePinHandler>(0).onError(oneginiChangePinError)
        }

        ChangePinUseCase(clientMock)(resultSpy)

        verify(resultSpy).error(oneginiChangePinError.errorType.toString(), oneginiChangePinError.message, null)
    }

    @Test
    fun `should return true when sdk return success`() {
        whenever(userClientMock.changePin(any())).thenAnswer {
            it.getArgument<OneginiChangePinHandler>(0).onSuccess()
        }

        ChangePinUseCase(clientMock)(resultSpy)

        verify(resultSpy).success(true)
    }
}