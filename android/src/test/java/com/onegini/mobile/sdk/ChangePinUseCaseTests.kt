package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.android.handlers.OneginiChangePinHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiChangePinError
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.SdkErrorAssert
import com.onegini.mobile.sdk.flutter.pigeonPlugin.FlutterError
import com.onegini.mobile.sdk.flutter.useCases.ChangePinUseCase
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Answers
import org.mockito.Mock
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.any
import org.mockito.kotlin.argumentCaptor
import org.mockito.kotlin.verify
import org.mockito.kotlin.whenever
import org.robolectric.util.ReflectionHelpers

@RunWith(MockitoJUnitRunner::class)
class ChangePinUseCaseTests {
    @Mock(answer = Answers.RETURNS_DEEP_STUBS)
    lateinit var oneginiSdk: OneginiSDK

    @Mock
    lateinit var callbackMock: (Result<Unit>) -> Unit

    @Mock
    lateinit var oneginiChangePinError: OneginiChangePinError

    private lateinit var changePinUseCase: ChangePinUseCase

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

        changePinUseCase(callbackMock)

        argumentCaptor<Result<Unit>>().apply {
            verify(callbackMock).invoke(capture())
            Assert.assertEquals(firstValue.getOrNull(), Unit)
        }
    }

    @Test
    fun `When onError is called on OneginiChangePinHandler, Then should fail with that error `() {
        whenever(oneginiSdk.oneginiClient.userClient.changePin(any())).thenAnswer {
            it.getArgument<OneginiChangePinHandler>(0).onError(oneginiChangePinError)
        }

        changePinUseCase(callbackMock)

        argumentCaptor<Result<Unit>>().apply {
            verify(callbackMock).invoke(capture())
            val expected = FlutterError(oneginiChangePinError.errorType.toString(), oneginiChangePinError.message)
            SdkErrorAssert.assertEquals(expected, firstValue.exceptionOrNull())
        }
    }

    private fun setupErrorMock() {
        whenever(oneginiChangePinError.message).thenReturn("message")
        ReflectionHelpers.setField(oneginiChangePinError, "errorType", 1000);
    }
}