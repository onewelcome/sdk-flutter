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

import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Mock
import org.mockito.Spy
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.eq
import org.mockito.kotlin.verify
import org.mockito.kotlin.whenever

@RunWith(MockitoJUnitRunner::class)
class AcceptPinAuthenticationUseCaseTests {

    @Mock
    lateinit var callMock: MethodCall

    @Mock
    lateinit var oneginiSDKMock: OneginiSDK

    @Mock
    lateinit var pinAuthenticationRequestHandlerMock: PinAuthenticationRequestHandler

    @Spy
    lateinit var oneginiPinCallbackMock: OneginiPinCallback

    @Mock
    lateinit var authenticationAttemptCounterMock: AuthenticationAttemptCounter

    @Mock
    lateinit var eventMock: EventChannel.EventSink

    @Mock
    lateinit var oneginiEventsSender: OneginiEventsSender

    @Before
    fun attach() {
        whenever(oneginiEventsSender.events).thenReturn(eventMock)
    }

    @Test
    fun `should return success with correct event when authentication is started`() {
        PinAuthenticationRequestHandler(oneginiEventsSender).startAuthentication(UserProfile("QWERTY"), oneginiPinCallbackMock, authenticationAttemptCounterMock)

        verify(oneginiEventsSender.events)?.success(eq(Constants.EVENT_OPEN_PIN_AUTH))
    }

    @Test
    fun `should return success with correct event when onNextAuthenticationAttempt was calls`() {
        whenever(authenticationAttemptCounterMock.maxAttempts).thenReturn(0)
        whenever(authenticationAttemptCounterMock.failedAttempts).thenReturn(0)
        whenever(authenticationAttemptCounterMock.remainingAttempts).thenReturn(0)

        PinAuthenticationRequestHandler(oneginiEventsSender).onNextAuthenticationAttempt(authenticationAttemptCounterMock)

        val attemptCounterJson = Gson().toJson(mapOf("maxAttempts" to authenticationAttemptCounterMock.maxAttempts, "failedAttempts" to authenticationAttemptCounterMock.failedAttempts, "remainingAttempts" to authenticationAttemptCounterMock.remainingAttempts))
        val expectedResult = Gson().toJson(OneginiEvent(Constants.EVENT_NEXT_AUTHENTICATION_ATTEMPT, attemptCounterJson))
        verify(oneginiEventsSender.events)?.success(expectedResult)
    }

    @Test
    fun `should return success with correct event when finishAuthentication was calls`() {
        PinAuthenticationRequestHandler(oneginiEventsSender).finishAuthentication()

        verify(oneginiEventsSender.events)?.success(Constants.EVENT_CLOSE_PIN_AUTH)
    }

    @Test
    fun `should call acceptAuthenticationRequest with pin as same as given`() {
        whenever(pinAuthenticationRequestHandlerMock.getCallback()).thenReturn(oneginiPinCallbackMock)
        whenever(oneginiSDKMock.getPinAuthenticationRequestHandler()).thenReturn(pinAuthenticationRequestHandlerMock)
        whenever(callMock.argument<String>("pin")).thenReturn("123456")

        AcceptPinAuthenticationUseCase(oneginiSDKMock)(callMock)

        verify(oneginiPinCallbackMock).acceptAuthenticationRequest(eq("123456".toCharArray()))
    }


}