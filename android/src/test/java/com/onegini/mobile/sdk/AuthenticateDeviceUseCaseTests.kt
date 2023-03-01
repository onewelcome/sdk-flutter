package com.onegini.mobile.sdk

import com.google.common.truth.Truth
import com.onegini.mobile.sdk.android.handlers.OneginiDeviceAuthenticationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiDeviceAuthenticationError
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.useCases.AuthenticateDeviceUseCase
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Answers
import org.mockito.ArgumentMatchers
import org.mockito.Mock
import org.mockito.Spy
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.any
import org.mockito.kotlin.argumentCaptor
import org.mockito.kotlin.eq
import org.mockito.kotlin.isNull
import org.mockito.kotlin.verify
import org.mockito.kotlin.whenever@RunWith(MockitoJUnitRunner::class)
class AuthenticateDeviceUseCaseTests {

    @Mock(answer = Answers.RETURNS_DEEP_STUBS)
    lateinit var oneginiSdk: OneginiSDK

    @Mock
    lateinit var oneginiDeviceAuthenticationErrorMock: OneginiDeviceAuthenticationError

    @Mock
    lateinit var callMock: MethodCall

    @Spy
    lateinit var resultSpy: MethodChannel.Result

    lateinit var authenticateDeviceUseCase: AuthenticateDeviceUseCase

    @Before
    fun attach() {
        authenticateDeviceUseCase = AuthenticateDeviceUseCase(oneginiSdk)
    }

    @Test
    fun `should return error when sdk returned authentication error`() {
        whenever(callMock.argument<ArrayList<String>>("scope")).thenReturn(null)
        whenever(oneginiDeviceAuthenticationErrorMock.errorType).thenReturn(OneginiDeviceAuthenticationError.GENERAL_ERROR)
        whenever(oneginiDeviceAuthenticationErrorMock.message).thenReturn("General error")
        whenever(oneginiSdk.oneginiClient.deviceClient.authenticateDevice(isNull(), any())).thenAnswer {
            it.getArgument<OneginiDeviceAuthenticationHandler>(1).onError(oneginiDeviceAuthenticationErrorMock)
        }
        authenticateDeviceUseCase(callMock, resultSpy)

        val message = oneginiDeviceAuthenticationErrorMock.message
        verify(resultSpy).error(eq(oneginiDeviceAuthenticationErrorMock.errorType.toString()), eq(message), any())
    }

    @Test
    fun `should return success when SDK returned authentication success`() {
        whenever(callMock.argument<ArrayList<String>>("scope")).thenReturn(arrayListOf("test"))
        whenever(oneginiSdk.oneginiClient.deviceClient.authenticateDevice(eq(arrayOf("test")), any())).thenAnswer {
            it.getArgument<OneginiDeviceAuthenticationHandler>(1).onSuccess()
        }
        authenticateDeviceUseCase(callMock, resultSpy)

        verify(resultSpy).success(true)
    }

    @Test
    fun `should scopes param be array of two scopes when given scopes contains two strings`() {
        whenever(callMock.argument<ArrayList<String>>("scope")).thenReturn(arrayListOf("read", "write"))

        authenticateDeviceUseCase(callMock, resultSpy)

        argumentCaptor<Array<String>> {
            verify(oneginiSdk.oneginiClient.deviceClient).authenticateDevice(capture(), ArgumentMatchers.any())
            Truth.assertThat(firstValue.size).isEqualTo(2)
            Truth.assertThat(firstValue).isEqualTo(arrayOf("read", "write"))
        }
    }

}