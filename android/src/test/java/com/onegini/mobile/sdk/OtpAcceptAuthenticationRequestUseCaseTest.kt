package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiAcceptDenyCallback
import com.onegini.mobile.sdk.android.model.entity.OneginiMobileAuthenticationRequest
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.OTP_AUTHENTICATION_NOT_IN_PROGRESS
import com.onegini.mobile.sdk.flutter.SdkErrorAssert
import com.onegini.mobile.sdk.flutter.handlers.MobileAuthOtpRequestHandler
import com.onegini.mobile.sdk.flutter.pigeonPlugin.NativeCallFlutterApi
import com.onegini.mobile.sdk.flutter.useCases.OtpAcceptAuthenticationRequestUseCase
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Mock
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.verify

@RunWith(MockitoJUnitRunner::class)
class OtpAcceptAuthenticationRequestUseCaseTest {
  @Mock
  lateinit var oneginiAcceptDenyCallback: OneginiAcceptDenyCallback

  @Mock
  lateinit var oneginiMobileAuthenticationRequest: OneginiMobileAuthenticationRequest

  @Mock
  lateinit var nativeApi: NativeCallFlutterApi

  lateinit var otpAcceptAuthenticationRequestUseCase: OtpAcceptAuthenticationRequestUseCase

  lateinit var mobileAuthOtpRequestHandler: MobileAuthOtpRequestHandler
  @Before
  fun attach() {
    mobileAuthOtpRequestHandler = MobileAuthOtpRequestHandler(nativeApi)
    otpAcceptAuthenticationRequestUseCase = OtpAcceptAuthenticationRequestUseCase(mobileAuthOtpRequestHandler)
  }

  @Test
  fun `When no otp authentication callback is set, Then it should resolve with an error`() {
    val result = otpAcceptAuthenticationRequestUseCase().exceptionOrNull()

    SdkErrorAssert.assertEquals(OTP_AUTHENTICATION_NOT_IN_PROGRESS, result)
  }

  @Test
  fun `When a otp authentication callback is set, Then it should resolve successfully`() {
    WhenOTPAuthenticationHasStarted()

    val result = otpAcceptAuthenticationRequestUseCase().getOrNull()

    Assert.assertEquals(Unit, result)
  }

  @Test
  fun `When a otp authentication callback is set, Then it should call the accept on the sdk callback`() {
    WhenOTPAuthenticationHasStarted()

    otpAcceptAuthenticationRequestUseCase().getOrNull()

    verify(oneginiAcceptDenyCallback).acceptAuthenticationRequest()
  }

  private fun WhenOTPAuthenticationHasStarted() {
    mobileAuthOtpRequestHandler.startAuthentication(oneginiMobileAuthenticationRequest, oneginiAcceptDenyCallback)
  }
}
