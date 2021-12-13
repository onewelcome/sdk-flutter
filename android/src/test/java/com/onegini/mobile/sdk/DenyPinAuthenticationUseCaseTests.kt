package com.onegini.mobile.sdk

import com.google.gson.Gson
import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiPinCallback
import com.onegini.mobile.sdk.android.model.entity.AuthenticationAttemptCounter
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.constants.Constants
import com.onegini.mobile.sdk.flutter.handlers.PinAuthenticationRequestHandler
import com.onegini.mobile.sdk.flutter.helpers.OneginiEventsSender
import com.onegini.mobile.sdk.flutter.models.OneginiEvent
import com.onegini.mobile.sdk.flutter.useCases.AcceptPinAuthenticationUseCase
import com.onegini.mobile.sdk.flutter.useCases.DenyPinAuthenticationUseCase

import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Mock
import org.mockito.Spy
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.eq
import org.mockito.kotlin.times
import org.mockito.kotlin.verify
import org.mockito.kotlin.whenever

@RunWith(MockitoJUnitRunner::class)
class DenyPinAuthenticationUseCaseTests {

    @Mock
    lateinit var callMock: MethodCall

    @Mock
    lateinit var oneginiSDKMock: OneginiSDK

    @Mock
    lateinit var pinAuthenticationRequestHandlerMock: PinAuthenticationRequestHandler

    @Mock
    lateinit var oneginiPinCallbackMock: OneginiPinCallback

    @Test
    fun `should call denyAuthenticationRequest`() {
        whenever(oneginiSDKMock.getPinAuthenticationRequestHandler()).thenReturn(pinAuthenticationRequestHandlerMock)
        whenever(pinAuthenticationRequestHandlerMock.getCallback()).thenReturn(oneginiPinCallbackMock)

        DenyPinAuthenticationUseCase(oneginiSDKMock)()

        verify(oneginiPinCallbackMock).denyAuthenticationRequest()
    }


}