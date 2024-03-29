package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiFingerprintCallback
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.NOT_IN_PROGRESS_FINGERPRINT_AUTHENTICATION
import com.onegini.mobile.sdk.flutter.SdkErrorAssert
import com.onegini.mobile.sdk.flutter.handlers.FingerprintAuthenticationRequestHandler
import com.onegini.mobile.sdk.flutter.pigeonPlugin.NativeCallFlutterApi
import com.onegini.mobile.sdk.flutter.useCases.FingerprintAuthenticationRequestAcceptUseCase
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Mock
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.verify

@RunWith(MockitoJUnitRunner::class)
class FingerprintAuthenticationRequestAcceptUseCaseTest {
  @Mock
  lateinit var oneginiFingerprintCallbackMock: OneginiFingerprintCallback

  @Mock
  lateinit var nativeApi: NativeCallFlutterApi

  private lateinit var fingerprintAuthenticationRequestAcceptUseCase: FingerprintAuthenticationRequestAcceptUseCase

  private lateinit var fingerprintAuthenticationRequestHandler: FingerprintAuthenticationRequestHandler

  @Before
  fun attach() {
    fingerprintAuthenticationRequestHandler = FingerprintAuthenticationRequestHandler(nativeApi)
    fingerprintAuthenticationRequestAcceptUseCase = FingerprintAuthenticationRequestAcceptUseCase(fingerprintAuthenticationRequestHandler)
  }

  @Test
  fun `When no fingerprint authentication callback is set, Then it should fail with an error`() {
    val result = fingerprintAuthenticationRequestAcceptUseCase().exceptionOrNull()

    SdkErrorAssert.assertEquals(NOT_IN_PROGRESS_FINGERPRINT_AUTHENTICATION, result)
  }

  @Test
  fun `When a pin authentication callback is set, Then it should resolve successfully`() {
    whenFingerPrintHasStarted()

    val result = fingerprintAuthenticationRequestAcceptUseCase().getOrNull()

    Assert.assertEquals(Unit, result)
  }

  @Test
  fun `When a pin authentication callback is set, Then it should call accept on the sdk callback`() {
    whenFingerPrintHasStarted()

    fingerprintAuthenticationRequestAcceptUseCase()

    verify(oneginiFingerprintCallbackMock).acceptAuthenticationRequest()
  }

  private fun whenFingerPrintHasStarted() {
    fingerprintAuthenticationRequestHandler.startAuthentication(UserProfile("123456"), oneginiFingerprintCallbackMock)
  }
}
