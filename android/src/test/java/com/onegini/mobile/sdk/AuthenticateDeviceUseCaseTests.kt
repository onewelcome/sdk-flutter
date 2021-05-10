package com.onegini.mobile.sdk

import com.google.common.truth.Truth
import com.onegini.mobile.sdk.android.client.DeviceClient
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.handlers.OneginiDeviceAuthenticationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiDeviceAuthenticationError
import com.onegini.mobile.sdk.flutter.useCases.AuthenticateDeviceUseCase
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
import org.mockito.kotlin.*

@RunWith(MockitoJUnitRunner::class)
class AuthenticateDeviceUseCaseTests {

    @Mock
    lateinit var clientMock: OneginiClient

    @Mock
    lateinit var oneginiDeviceAuthenticationErrorMock: OneginiDeviceAuthenticationError

    @Mock
    lateinit var deviceClientMock: DeviceClient

    @Mock
    lateinit var callMock: MethodCall

    @Spy
    lateinit var resultSpy: MethodChannel.Result

    @Before
    fun attach() {
        whenever(clientMock.deviceClient).thenReturn(deviceClientMock)
    }

    @Test
    fun `should return error when scopes is null`() {
        whenever(callMock.argument<ArrayList<String>>("scope")).thenReturn(null)
        whenever(oneginiDeviceAuthenticationErrorMock.errorType).thenReturn(OneginiDeviceAuthenticationError.GENERAL_ERROR)
        whenever(oneginiDeviceAuthenticationErrorMock.message).thenReturn("General error")
        whenever(deviceClientMock.authenticateDevice(isNull(), any())).thenAnswer {
            it.getArgument<OneginiDeviceAuthenticationHandler>(1).onError(oneginiDeviceAuthenticationErrorMock)
        }
        AuthenticateDeviceUseCase(clientMock)(callMock, resultSpy)

        verify(resultSpy).error(oneginiDeviceAuthenticationErrorMock.errorType.toString(), oneginiDeviceAuthenticationErrorMock.message, null)
    }

    @Test
    fun `should return success when scopes is correct`() {
        whenever(callMock.argument<ArrayList<String>>("scope")).thenReturn(arrayListOf("test"))
        whenever(deviceClientMock.authenticateDevice(eq(arrayOf("test")), any())).thenAnswer {
            it.getArgument<OneginiDeviceAuthenticationHandler>(1).onSuccess()
        }
        AuthenticateDeviceUseCase(clientMock)(callMock, resultSpy)

        verify(resultSpy).success(true)
    }

    @Test
    fun `should scopes param be array of two scopes when given scopes contains two strings`() {
        whenever(callMock.argument<ArrayList<String>>("scope")).thenReturn(arrayListOf("read", "write"))

        AuthenticateDeviceUseCase(clientMock)(callMock, resultSpy)

        argumentCaptor<Array<String>> {
            Mockito.verify(deviceClientMock).authenticateDevice(capture(), ArgumentMatchers.any())
            Truth.assertThat(firstValue.size).isEqualTo(2)
            Truth.assertThat(firstValue).isEqualTo(arrayOf("read", "write"))
        }
    }

}