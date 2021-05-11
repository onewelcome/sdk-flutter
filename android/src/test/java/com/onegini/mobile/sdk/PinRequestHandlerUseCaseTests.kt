package com.onegini.mobile.sdk

import com.google.common.truth.Truth
import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiPinCallback
import com.onegini.mobile.sdk.flutter.useCases.PinRequestHandlerUseCase
import io.flutter.plugin.common.MethodCall
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Mock
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.argumentCaptor
import org.mockito.kotlin.verify
import org.mockito.kotlin.whenever

@RunWith(MockitoJUnitRunner::class)
class PinRequestHandlerUseCaseTests {
    @Mock
    lateinit var oneginiPinCallback: OneginiPinCallback

    @Mock
    lateinit var callMock: MethodCall

    @Test
    fun `should match pin as parameter when pin is not null`() {
        whenever(callMock.argument<String>("pin")).thenReturn("12345")

        PinRequestHandlerUseCase(oneginiPinCallback).acceptAuthenticationRequest(callMock)

        argumentCaptor<CharArray> {
            verify(oneginiPinCallback).acceptAuthenticationRequest(capture())
            Truth.assertThat(firstValue).isEqualTo("12345".toCharArray())
        }
    }

    @Test
    fun `should match pin as parameter when pin is null`() {
        PinRequestHandlerUseCase(oneginiPinCallback).acceptAuthenticationRequest(callMock)

        argumentCaptor<CharArray> {
            verify(oneginiPinCallback).acceptAuthenticationRequest(capture())
            Truth.assertThat(firstValue).isNull()
        }
    }
}