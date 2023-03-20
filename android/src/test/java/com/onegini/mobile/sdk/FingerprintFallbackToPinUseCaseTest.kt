package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiFingerprintCallback
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.FINGERPRINT_AUTHENTICATION_NOT_IN_PROGRESS
import com.onegini.mobile.sdk.flutter.SdkErrorAssert
import com.onegini.mobile.sdk.flutter.handlers.FingerprintAuthenticationRequestHandler
import com.onegini.mobile.sdk.flutter.useCases.FingerprintFallbackToPinUseCase
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Mock
import org.mockito.junit.MockitoJUnitRunner

@RunWith(MockitoJUnitRunner::class)
class FingerprintFallbackToPinUseCaseTest {

  @Mock
  lateinit var oneginiFingerprintCallbackMock: OneginiFingerprintCallback

  @Mock
  lateinit var callbackMock: (Result<Unit>) -> Unit

  lateinit var fingerprintFallbackToPinUseCase: FingerprintFallbackToPinUseCase

  @Before
  fun attach() {
    fingerprintFallbackToPinUseCase = FingerprintFallbackToPinUseCase()
  }

  @Test
  fun `When no fingerprint authentication callback is set, Then it should resolve with an error`() {
    FingerprintAuthenticationRequestHandler.fingerprintCallback = null

    val result = fingerprintFallbackToPinUseCase().exceptionOrNull()
    SdkErrorAssert.assertEquals(FINGERPRINT_AUTHENTICATION_NOT_IN_PROGRESS, result)
  }

  @Test
  fun `When a pin authentication callback is set, Then it should resolve successfully`() {
    FingerprintAuthenticationRequestHandler.fingerprintCallback = oneginiFingerprintCallbackMock

    val result = fingerprintFallbackToPinUseCase().getOrNull()
    Assert.assertEquals(Unit, result)
  }
}
