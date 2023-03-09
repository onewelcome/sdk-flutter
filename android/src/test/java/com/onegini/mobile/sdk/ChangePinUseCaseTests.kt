package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.handlers.OneginiChangePinHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiChangePinError
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.useCases.ChangePinUseCase
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Answers
import org.mockito.Mock
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.any
import org.mockito.kotlin.eq
import org.mockito.kotlin.verify
import org.mockito.kotlin.whenever

@RunWith(MockitoJUnitRunner::class)
class ChangePinUseCaseTests {

    @Mock(answer = Answers.RETURNS_DEEP_STUBS)
    lateinit var oneginiSdk: OneginiSDK

    @Mock
    lateinit var clientMock: OneginiClient

    @Mock
    lateinit var callMock: MethodCall

    @Mock
    lateinit var resultMock: MethodChannel.Result

    @Mock
    lateinit var oneginiChangePinError: OneginiChangePinError

    lateinit var changePinUseCase: ChangePinUseCase

    @Before
    fun setup() {
        changePinUseCase = ChangePinUseCase(oneginiSdk)
        setupErrorMock()
    }

    @Test
    fun `When onSuccess is called on OneginiChangePinHandler, Then should succeed with Null `() {
        whenever(oneginiSdk.oneginiClient.userClient.changePin(any())).thenAnswer {
            it.getArgument<OneginiChangePinHandler>(0).onSuccess()
        }

        changePinUseCase(resultMock)

        verify(resultMock).success(null)
    }

    @Test
    fun `When onError is called on OneginiChangePinHandler, Then should fail with that error `() {
        whenever(oneginiSdk.oneginiClient.userClient.changePin(any())).thenAnswer {
            it.getArgument<OneginiChangePinHandler>(0).onError(oneginiChangePinError)
        }

        changePinUseCase(resultMock)

        val message = oneginiChangePinError.message
        verify(resultMock).error(eq(oneginiChangePinError.errorType.toString()), eq(message), any())
    }

    private fun setupErrorMock() {
        whenever(oneginiChangePinError.message).thenReturn("message")
        whenever(oneginiChangePinError.errorType).thenReturn(1000)
    }
}
