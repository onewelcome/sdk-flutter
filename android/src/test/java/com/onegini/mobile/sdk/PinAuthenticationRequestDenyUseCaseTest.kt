package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiPinCallback
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.AUTHENTICATION_NOT_IN_PROGRESS
import com.onegini.mobile.sdk.flutter.SdkErrorAssert
import com.onegini.mobile.sdk.flutter.handlers.PinAuthenticationRequestHandler
import com.onegini.mobile.sdk.flutter.useCases.PinAuthenticationRequestDenyUseCase
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Mock
import org.mockito.junit.MockitoJUnitRunner

@RunWith(MockitoJUnitRunner::class)
class PinAuthenticationRequestDenyUseCaseTest {

  @Mock
  lateinit var oneginiPinCallbackMock: OneginiPinCallback

  @Mock
  lateinit var callbackMock: (Result<Unit>) -> Unit

  lateinit var pinAuthenticationRequestDenyUseCase: PinAuthenticationRequestDenyUseCase

  @Before
  fun attach() {
    pinAuthenticationRequestDenyUseCase = PinAuthenticationRequestDenyUseCase()
  }

  @Test
  fun `When no pin registration callback is set, Then it should resolve with an error`() {
    PinAuthenticationRequestHandler.callback = null

    val result = pinAuthenticationRequestDenyUseCase().exceptionOrNull()
    SdkErrorAssert.assertEquals(AUTHENTICATION_NOT_IN_PROGRESS, result)
  }

  @Test
  fun `When a pin registration callback is set, Then it should resolve successfully`() {
    PinAuthenticationRequestHandler.callback = oneginiPinCallbackMock

    val result = pinAuthenticationRequestDenyUseCase().getOrNull()
    Assert.assertEquals(Unit, result)
  }
}
