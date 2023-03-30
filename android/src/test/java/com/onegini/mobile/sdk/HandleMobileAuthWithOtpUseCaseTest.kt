package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.android.handlers.OneginiMobileAuthWithOtpHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiMobileAuthEnrollmentError
import com.onegini.mobile.sdk.android.handlers.error.OneginiMobileAuthWithOtpError
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.SdkErrorAssert
import com.onegini.mobile.sdk.flutter.pigeonPlugin.FlutterError
import com.onegini.mobile.sdk.flutter.useCases.HandleMobileAuthWithOtpUseCase
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Answers
import org.mockito.Mock
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.any
import org.mockito.kotlin.argumentCaptor
import org.mockito.kotlin.verify
import org.mockito.kotlin.whenever

@RunWith(MockitoJUnitRunner::class)
class HandleMobileAuthWithOtpUseCaseTest {
  @Mock(answer = Answers.RETURNS_DEEP_STUBS)
  lateinit var oneginiSdk: OneginiSDK

  @Mock
  lateinit var otpErrorMock: OneginiMobileAuthWithOtpError

  @Mock
  lateinit var callbackMock: (Result<Unit>) -> Unit

  lateinit var handleMobileAuthWithOtpUseCase: HandleMobileAuthWithOtpUseCase

  @Before
  fun attach() {
    handleMobileAuthWithOtpUseCase = HandleMobileAuthWithOtpUseCase(oneginiSdk)
    whenever(otpErrorMock.errorType).thenReturn(OneginiMobileAuthWithOtpError.GENERAL_ERROR)
    whenever(otpErrorMock.message).thenReturn("General error")
  }

  @Test
  fun `When the sdk returns an otp authentication error, Then it should resolve with an error`() {
    whenever(oneginiSdk.oneginiClient.userClient.authenticatedUserProfile).thenReturn(UserProfile("QWERTY"))
    whenever(oneginiSdk.oneginiClient.userClient.handleMobileAuthWithOtp(any(), any())).thenAnswer {
      it.getArgument<OneginiMobileAuthWithOtpHandler>(1).onError(otpErrorMock)
    }

    handleMobileAuthWithOtpUseCase("otp_password", callbackMock)

    argumentCaptor<Result<Unit>>().apply {
      verify(callbackMock).invoke(capture())

      val expected = FlutterError(OneginiMobileAuthEnrollmentError.GENERAL_ERROR.toString(), "General error")
      SdkErrorAssert.assertEquals(expected, firstValue.exceptionOrNull())
    }
  }

  @Test
  fun `When the sdk succeeds with the otp authentication, Then it should resolve successfully`() {
    whenever(oneginiSdk.oneginiClient.userClient.authenticatedUserProfile).thenReturn(UserProfile("QWERTY"))
    whenever(oneginiSdk.oneginiClient.userClient.handleMobileAuthWithOtp(any(), any())).thenAnswer {
      it.getArgument<OneginiMobileAuthWithOtpHandler>(1).onSuccess()
    }

    handleMobileAuthWithOtpUseCase("otp_password", callbackMock)

    argumentCaptor<Result<Unit>>().apply {
      verify(callbackMock).invoke(capture())

      Assert.assertEquals(firstValue.getOrNull(), Unit)
    }
  }
}
