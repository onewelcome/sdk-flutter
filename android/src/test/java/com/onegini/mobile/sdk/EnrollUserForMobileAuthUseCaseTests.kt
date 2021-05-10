package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.client.UserClient
import com.onegini.mobile.sdk.android.handlers.OneginiMobileAuthEnrollmentHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiMobileAuthEnrollmentError
import com.onegini.mobile.sdk.android.handlers.error.OneginiMobileAuthWithOtpError
import com.onegini.mobile.sdk.flutter.useCases.EnrollUserForMobileAuthUseCase
import io.flutter.plugin.common.MethodChannel
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Mock
import org.mockito.Spy
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.any
import org.mockito.kotlin.verify
import org.mockito.kotlin.whenever

@RunWith(MockitoJUnitRunner::class)
class EnrollUserForMobileAuthUseCaseTests {
    @Mock
    lateinit var clientMock: OneginiClient

    @Mock
    lateinit var userClientMock: UserClient

    @Spy
    lateinit var resultSpy: MethodChannel.Result

    @Mock
    lateinit var oneginiMobileAuthEnrollmentError: OneginiMobileAuthEnrollmentError

    @Before
    fun attach() {
        whenever(clientMock.userClient).thenReturn(userClientMock)
    }

    @Test
    fun `should return success when enrollUserForMobileAuth method return success`() {
        whenever(userClientMock.enrollUserForMobileAuth(any())).thenAnswer {
            it.getArgument<OneginiMobileAuthEnrollmentHandler>(0).onSuccess()
        }

        EnrollUserForMobileAuthUseCase(clientMock)(resultSpy)

        verify(resultSpy).success(true)
    }

    @Test
    fun `should return error when enrollUserForMobileAuth return error`() {
        whenever(oneginiMobileAuthEnrollmentError.errorType).thenReturn(OneginiMobileAuthWithOtpError.GENERAL_ERROR)
        whenever(oneginiMobileAuthEnrollmentError.message).thenReturn("General error")
        whenever(userClientMock.enrollUserForMobileAuth(any())).thenAnswer {
            it.getArgument<OneginiMobileAuthEnrollmentHandler>(0).onError(oneginiMobileAuthEnrollmentError)
        }

        EnrollUserForMobileAuthUseCase(clientMock)(resultSpy)

        verify(resultSpy).error(oneginiMobileAuthEnrollmentError.errorType.toString(), oneginiMobileAuthEnrollmentError.message, null)
    }


}