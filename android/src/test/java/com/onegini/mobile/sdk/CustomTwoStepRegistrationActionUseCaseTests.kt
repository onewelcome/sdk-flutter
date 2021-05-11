package com.onegini.mobile.sdk

import com.google.common.truth.Truth
import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiCustomRegistrationCallback
import com.onegini.mobile.sdk.flutter.useCases.CustomTwoStepRegistrationActionUseCase
import io.flutter.plugin.common.MethodCall
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Mock
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.argumentCaptor
import org.mockito.kotlin.verify
import org.mockito.kotlin.whenever

@RunWith(MockitoJUnitRunner::class)
class CustomTwoStepRegistrationActionUseCaseTests {

    @Mock
    lateinit var oneginiCustomRegistrationCallback: OneginiCustomRegistrationCallback

    @Mock
    lateinit var callMock: MethodCall

    @Test
    fun `should match data as parameter when data is not null`() {
        whenever(callMock.argument<String>("data")).thenReturn("data")

        CustomTwoStepRegistrationActionUseCase(oneginiCustomRegistrationCallback).returnSuccess(callMock)

        argumentCaptor<String> {
            verify(oneginiCustomRegistrationCallback).returnSuccess(capture())
            Truth.assertThat(firstValue).isEqualTo("data")
        }
    }

    @Test
    fun `should match data as parameter when data is null`() {
        CustomTwoStepRegistrationActionUseCase(oneginiCustomRegistrationCallback).returnSuccess(callMock)

        argumentCaptor<String> {
            verify(oneginiCustomRegistrationCallback).returnSuccess(capture())
            Truth.assertThat(firstValue).isNull()
        }
    }

    @Test
    fun `should match error as parameter when call onError method with null error message`() {
        CustomTwoStepRegistrationActionUseCase(oneginiCustomRegistrationCallback).returnError(callMock)

        argumentCaptor<Exception> {
            verify(oneginiCustomRegistrationCallback).returnError(capture())
            Truth.assertThat(firstValue.message).isNull()
        }
    }

    @Test
    fun `should match error as parameter when call onError method with error message`() {
        whenever(callMock.argument<String>("error")).thenReturn("General error")

        CustomTwoStepRegistrationActionUseCase(oneginiCustomRegistrationCallback).returnError(callMock)

        argumentCaptor<Exception> {
            verify(oneginiCustomRegistrationCallback).returnError(capture())
            Truth.assertThat(firstValue.message).isEqualTo("General error")
        }
    }
}