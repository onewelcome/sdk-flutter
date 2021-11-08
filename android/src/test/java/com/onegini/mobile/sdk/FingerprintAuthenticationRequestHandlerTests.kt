package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiFingerprintCallback
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.constants.Constants
import com.onegini.mobile.sdk.flutter.handlers.FingerprintAuthenticationRequestHandler
import com.onegini.mobile.sdk.flutter.helpers.OneginiEventsSender
import io.flutter.plugin.common.EventChannel
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Mock
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.verify
import org.mockito.kotlin.whenever

@RunWith(MockitoJUnitRunner::class)
class FingerprintAuthenticationRequestHandlerTests {

    @Mock
    lateinit var oneginiFingerprintCallbackMock: OneginiFingerprintCallback

    @Mock
    lateinit var eventMock: EventChannel.EventSink

    @Mock
    lateinit var oneginiEventsSender: OneginiEventsSender

    @Before
    fun attach() {
        whenever(oneginiEventsSender.events).thenReturn(eventMock)
    }

    @Test
    fun `should return success with correct event when startAuthentication was calls`() {
        FingerprintAuthenticationRequestHandler(oneginiEventsSender).startAuthentication(UserProfile("QWERTY"), oneginiFingerprintCallbackMock)

        verify(oneginiEventsSender.events)?.success(Constants.EVENT_OPEN_FINGERPRINT_AUTH)
    }

    @Test
    fun `should return success with correct event when onNextAuthenticationAttempt was calls`() {
        FingerprintAuthenticationRequestHandler(oneginiEventsSender).onNextAuthenticationAttempt()

        verify(oneginiEventsSender.events)?.success(Constants.EVENT_RECEIVED_FINGERPRINT_AUTH)
    }

    @Test
    fun `should return success with correct event when onFingerprintCaptured was calls`() {
        FingerprintAuthenticationRequestHandler(oneginiEventsSender).onFingerprintCaptured()

        verify(oneginiEventsSender.events)?.success(Constants.EVENT_SHOW_SCANNING_FINGERPRINT_AUTH)
    }

    @Test
    fun `should return success with correct event when finishAuthentication was calls`() {
        FingerprintAuthenticationRequestHandler(oneginiEventsSender).finishAuthentication()

        verify(oneginiEventsSender.events)?.success(Constants.EVENT_CLOSE_FINGERPRINT_AUTH)
    }

}