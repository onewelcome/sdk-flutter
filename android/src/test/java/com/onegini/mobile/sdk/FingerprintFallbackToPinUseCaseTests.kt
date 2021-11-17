package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiFingerprintCallback
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.handlers.FingerprintAuthenticationRequestHandler
import com.onegini.mobile.sdk.flutter.useCases.FingerprintFallbackToPinUseCase
import io.flutter.plugin.common.MethodCall
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Mock
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.verify
import org.mockito.kotlin.whenever

@RunWith(MockitoJUnitRunner::class)
class FingerprintFallbackToPinUseCaseTests {
    @Mock
    lateinit var callMock: MethodCall

    @Mock
    lateinit var oneginiSDKMock: OneginiSDK

    @Mock
    lateinit var fingerprintAuthenticationRequestHandlerMock: FingerprintAuthenticationRequestHandler

    @Mock
    lateinit var oneginiFingerprintCallbackMock: OneginiFingerprintCallback

    @Test
    fun `should call denyAuthenticationRequest`() {
        whenever(oneginiSDKMock.getFingerprintAuthenticationRequestHandler()).thenReturn(fingerprintAuthenticationRequestHandlerMock)
        whenever(fingerprintAuthenticationRequestHandlerMock.fingerprintCallback).thenReturn(oneginiFingerprintCallbackMock)

        FingerprintFallbackToPinUseCase(oneginiSDKMock)()

        verify(oneginiFingerprintCallbackMock).fallbackToPin()
    }
}