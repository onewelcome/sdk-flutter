package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiAcceptDenyCallback
import com.onegini.mobile.sdk.android.model.entity.OneginiMobileAuthenticationRequest
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.NOT_IN_PROGRESS_OTP_AUTHENTICATION
import com.onegini.mobile.sdk.flutter.SdkErrorAssert
import com.onegini.mobile.sdk.flutter.handlers.MobileAuthOtpRequestHandler
import com.onegini.mobile.sdk.flutter.pigeonPlugin.NativeCallFlutterApi
import com.onegini.mobile.sdk.flutter.useCases.OtpDenyAuthenticationRequestUseCase
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Mock
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.verify

@RunWith(MockitoJUnitRunner::class)
class OtpDenyAuthenticationRequestUseCaseTest {
  @Mock
  lateinit var oneginiAcceptDenyCallback: OneginiAcceptDenyCallback

  @Mock
  lateinit var oneginiMobileAuthenticationRequest: OneginiMobileAuthenticationRequest

  @Mock
  lateinit var nativeApi: NativeCallFlutterApi

  private lateinit var otpDenyAuthenticationRequestUseCase: OtpDenyAuthenticationRequestUseCase

  private lateinit var mobileAuthOtpRequestHandler: MobileAuthOtpRequestHandler

  @Before
  fun attach() {
    mobileAuthOtpRequestHandler = MobileAuthOtpRequestHandler(nativeApi)
    otpDenyAuthenticationRequestUseCase = OtpDenyAuthenticationRequestUseCase(mobileAuthOtpRequestHandler)

  }

  @Test
  fun `When no otp authentication callback is set, Then it should resolve with an error`() {
    val result = otpDenyAuthenticationRequestUseCase().exceptionOrNull()
    SdkErrorAssert.assertEquals(NOT_IN_PROGRESS_OTP_AUTHENTICATION, result)
  }

  @Test
  fun `When a otp authentication callback is set, Then it should resolve successfully`() {
    whenOTPAuthenticationHasStarted()

    val result = otpDenyAuthenticationRequestUseCase().getOrNull()

    Assert.assertEquals(Unit, result)
  }

  @Test
  fun `When a otp authentication callback is set, Then it should call the deny on the sdk callback`() {
    whenOTPAuthenticationHasStarted()

    otpDenyAuthenticationRequestUseCase().getOrNull()

    verify(oneginiAcceptDenyCallback).denyAuthenticationRequest()
  }

  private fun whenOTPAuthenticationHasStarted() {
    mobileAuthOtpRequestHandler.startAuthentication(oneginiMobileAuthenticationRequest, oneginiAcceptDenyCallback)
  }
}
