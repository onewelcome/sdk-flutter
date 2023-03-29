package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiFingerprintCallback
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.FINGERPRINT_AUTHENTICATION_NOT_IN_PROGRESS
import com.onegini.mobile.sdk.flutter.SdkErrorAssert
import com.onegini.mobile.sdk.flutter.handlers.FingerprintAuthenticationRequestHandler
import com.onegini.mobile.sdk.flutter.pigeonPlugin.NativeCallFlutterApi
import com.onegini.mobile.sdk.flutter.useCases.FingerprintAuthenticationRequestDenyUseCase
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Mock
import org.mockito.junit.MockitoJUnitRunner

@RunWith(MockitoJUnitRunner::class)
class FingerprintAuthenticationRequestDenyUseCaseTest {

  @Mock
  lateinit var oneginiFingerprintCallbackMock: OneginiFingerprintCallback

  @Mock
  lateinit var nativeApi: NativeCallFlutterApi

  lateinit var fingerprintAuthenticationRequestDenyUseCase: FingerprintAuthenticationRequestDenyUseCase

  lateinit var fingerprintAuthenticationRequestHandler: FingerprintAuthenticationRequestHandler
  @Before
  fun attach() {
    fingerprintAuthenticationRequestHandler = FingerprintAuthenticationRequestHandler(nativeApi)
    fingerprintAuthenticationRequestDenyUseCase = FingerprintAuthenticationRequestDenyUseCase(fingerprintAuthenticationRequestHandler)
  }

  @Test
  fun `When no fingerprint authentication callback is set, Then it should fail with an error`() {
    val result = fingerprintAuthenticationRequestDenyUseCase().exceptionOrNull()

    SdkErrorAssert.assertEquals(FINGERPRINT_AUTHENTICATION_NOT_IN_PROGRESS, result)
  }

  @Test
  fun `When a pin authentication callback is set, Then it should resolve successfully`() {
    WhenFingerPrintHasStarted()

    val result = fingerprintAuthenticationRequestDenyUseCase().getOrNull()

    Assert.assertEquals(Unit, result)
  }

  fun WhenFingerPrintHasStarted() {
    fingerprintAuthenticationRequestHandler.startAuthentication(UserProfile("123456"), oneginiFingerprintCallbackMock)
  }
}
