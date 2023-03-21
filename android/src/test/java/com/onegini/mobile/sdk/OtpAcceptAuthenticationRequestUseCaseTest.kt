package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiAcceptDenyCallback
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.OTP_AUTHENTICATION_NOT_IN_PROGRESS
import com.onegini.mobile.sdk.flutter.SdkErrorAssert
import com.onegini.mobile.sdk.flutter.handlers.MobileAuthOtpRequestHandler
import com.onegini.mobile.sdk.flutter.useCases.OtpAcceptAuthenticationRequestUseCase
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Mock
import org.mockito.junit.MockitoJUnitRunner

@RunWith(MockitoJUnitRunner::class)
class OtpAcceptAuthenticationRequestUseCaseTest {
  @Mock
  lateinit var oneginiOtpCallbackMock: OneginiAcceptDenyCallback

  lateinit var otpAcceptAuthenticationRequestUseCase: OtpAcceptAuthenticationRequestUseCase

  @Before
  fun attach() {
    otpAcceptAuthenticationRequestUseCase = OtpAcceptAuthenticationRequestUseCase()
  }

  @Test
  fun `When no otp authentication callback is set, Then it should resolve with an error`() {
    MobileAuthOtpRequestHandler.CALLBACK = null

    val result = otpAcceptAuthenticationRequestUseCase().exceptionOrNull()
    SdkErrorAssert.assertEquals(OTP_AUTHENTICATION_NOT_IN_PROGRESS, result)
  }

  @Test
  fun `When a otp authentication callback is set, Then it should resolve successfully`() {
    MobileAuthOtpRequestHandler.CALLBACK = oneginiOtpCallbackMock

    val result = otpAcceptAuthenticationRequestUseCase().getOrNull()
    Assert.assertEquals(Unit, result)
  }
}
