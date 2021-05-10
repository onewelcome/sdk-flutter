package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.client.UserClient
import com.onegini.mobile.sdk.android.handlers.OneginiMobileAuthWithOtpHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiMobileAuthWithOtpError
import com.onegini.mobile.sdk.flutter.OneginiWrapperErrors
import com.onegini.mobile.sdk.flutter.useCases.HandleMobileAuthWithOtpUseCase
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Mock
import org.mockito.Spy
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.any
import org.mockito.kotlin.eq
import org.mockito.kotlin.verify
import org.mockito.kotlin.whenever

@RunWith(MockitoJUnitRunner::class)
class HandleMobileAuthWithOtpUSeCaseTests {
    @Mock
    lateinit var clientMock: OneginiClient

    @Mock
    lateinit var userClientMock: UserClient

    @Spy
    lateinit var resultSpy: MethodChannel.Result

    @Mock
    lateinit var callMock: MethodCall

    @Mock
    lateinit var oneginiMobileAuthWithOtpError: OneginiMobileAuthWithOtpError

    @Before
    fun attach() {
        whenever(clientMock.userClient).thenReturn(userClientMock)
    }

    @Test
    fun `should return error when given data param is null`() {
        HandleMobileAuthWithOtpUseCase(clientMock)(callMock, resultSpy)

        verify(resultSpy).error(OneginiWrapperErrors.QR_CODE_NOT_HAVE_DATA.code, OneginiWrapperErrors.QR_CODE_NOT_HAVE_DATA.message, null)
    }

    @Test
    fun `should return success when data is correct`() {
        whenever(callMock.argument<String>("data")).thenReturn("test")
        whenever(userClientMock.handleMobileAuthWithOtp(eq("test"), any())).thenAnswer {
            it.getArgument<OneginiMobileAuthWithOtpHandler>(1).onSuccess()
        }

        HandleMobileAuthWithOtpUseCase(clientMock)(callMock, resultSpy)

        verify(resultSpy).success(true)
    }

    @Test
    fun `should return error when data is not correct`() {
        whenever(callMock.argument<String>("data")).thenReturn("test")
        whenever(oneginiMobileAuthWithOtpError.errorType).thenReturn(OneginiMobileAuthWithOtpError.GENERAL_ERROR)
        whenever(oneginiMobileAuthWithOtpError.message).thenReturn("General error")
        whenever(userClientMock.handleMobileAuthWithOtp(eq("test"), any())).thenAnswer {
            it.getArgument<OneginiMobileAuthWithOtpHandler>(1).onError(oneginiMobileAuthWithOtpError)
        }

        HandleMobileAuthWithOtpUseCase(clientMock)(callMock, resultSpy)

        verify(resultSpy).error(oneginiMobileAuthWithOtpError.errorType.toString(), oneginiMobileAuthWithOtpError.message, null)
    }


}