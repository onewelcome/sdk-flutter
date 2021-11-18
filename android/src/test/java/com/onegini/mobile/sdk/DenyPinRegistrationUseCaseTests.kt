package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiPinCallback
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.handlers.PinRequestHandler
import com.onegini.mobile.sdk.flutter.useCases.DenyPinRegistrationUseCase
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Mock
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.verify
import org.mockito.kotlin.whenever

@RunWith(MockitoJUnitRunner::class)
class DenyPinRegistrationUseCaseTests {
    @Mock
    lateinit var oneginiSDKMock: OneginiSDK

    @Mock
    lateinit var pinRequestHandlerMock: PinRequestHandler

    @Mock
    lateinit var oneginiPinCallbackMock: OneginiPinCallback

    @Test
    fun `should call denyAuthenticationRequest`() {
        whenever(oneginiSDKMock.getPinRequestHandler()).thenReturn(pinRequestHandlerMock)
        whenever(pinRequestHandlerMock.getCallback()).thenReturn(oneginiPinCallbackMock)

        DenyPinRegistrationUseCase(oneginiSDKMock)()

        verify(oneginiPinCallbackMock).denyAuthenticationRequest()
    }

}