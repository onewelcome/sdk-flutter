package com.onegini.mobile.sdk

import com.google.gson.Gson
import com.onegini.mobile.sdk.android.handlers.error.OneginiPinValidationError
import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiPinCallback
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.constants.Constants
import com.onegini.mobile.sdk.flutter.handlers.PinRequestHandler
import com.onegini.mobile.sdk.flutter.helpers.OneginiEventsSender
import com.onegini.mobile.sdk.flutter.models.Error
import com.onegini.mobile.sdk.flutter.models.OneginiEvent
import com.onegini.mobile.sdk.flutter.useCases.AcceptPinRegistrationUseCase
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
class AcceptPinRegistrationUseCaseTests {
    @Mock
    lateinit var callMock: MethodCall

    @Mock
    lateinit var oneginiSDKMock: OneginiSDK

    @Mock
    lateinit var pinRequestHandlerMock: PinRequestHandler

    @Spy
    lateinit var oneginiPinCallbackMock: OneginiPinCallback

    @Mock
    lateinit var oneginiPinValidationError: OneginiPinValidationError

    @Mock
    lateinit var eventMock: EventChannel.EventSink

    @Mock
    lateinit var oneginiEventsSender: OneginiEventsSender

    @Before
    fun attach() {
        whenever(oneginiEventsSender.events).thenReturn(eventMock)
    }

    @Test
    fun `should return success with correct event when startPinCreation was calls`() {
        PinRequestHandler(oneginiEventsSender).startPinCreation(UserProfile("QWERTY"), oneginiPinCallbackMock, 1)

        verify(oneginiEventsSender.events)?.success(eq(Constants.EVENT_OPEN_PIN))
    }

    @Test
    fun `should return success with correct event when onNextPinCreationAttempt was calls`() {
        whenever(oneginiPinValidationError.message).thenReturn("error message")
        whenever(oneginiPinValidationError.errorType).thenReturn(0)

        PinRequestHandler(oneginiEventsSender).onNextPinCreationAttempt(oneginiPinValidationError)

        val expectedResult = Gson().toJson(OneginiEvent(Constants.EVENT_ERROR, Gson().toJson(Error(oneginiPinValidationError.errorType.toString(), oneginiPinValidationError.message
                ?: "")).toString()))

        verify(oneginiEventsSender.events)?.success(expectedResult)
    }

    @Test
    fun `should return success with correct event when finishPinCreation was calls`() {
        PinRequestHandler(oneginiEventsSender).finishPinCreation()

        verify(oneginiEventsSender.events)?.success(Constants.EVENT_CLOSE_PIN)
    }

    @Test
    fun `should call acceptAuthenticationRequest with pin as same as given`() {
        whenever(pinRequestHandlerMock.getCallback()).thenReturn(oneginiPinCallbackMock)
        whenever(oneginiSDKMock.getPinRequestHandler()).thenReturn(pinRequestHandlerMock)
        whenever(callMock.argument<String>("pin")).thenReturn("123456")

        AcceptPinRegistrationUseCase(oneginiSDKMock)(callMock)

        verify(oneginiPinCallbackMock).acceptAuthenticationRequest(eq("123456".toCharArray()))
    }

}