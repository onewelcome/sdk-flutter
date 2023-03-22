package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiPinCallback
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.AUTHENTICATION_NOT_IN_PROGRESS
import com.onegini.mobile.sdk.flutter.SdkErrorAssert
import com.onegini.mobile.sdk.flutter.handlers.PinAuthenticationRequestHandler
import com.onegini.mobile.sdk.flutter.useCases.PinAuthenticationRequestAcceptUseCase
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Mock
import org.mockito.junit.MockitoJUnitRunner

@RunWith(MockitoJUnitRunner::class)
class PinAuthenticationRequestAcceptUseCaseTest {

  @Mock
  lateinit var oneginiPinCallbackMock: OneginiPinCallback

  @Mock
  lateinit var callbackMock: (Result<Unit>) -> Unit

  lateinit var pinAuthenticationRequestAcceptUseCase: PinAuthenticationRequestAcceptUseCase

  @Before
  fun attach() {
    pinAuthenticationRequestAcceptUseCase = PinAuthenticationRequestAcceptUseCase()
  }

  @Test
  fun `When no pin registration callback is set, Then it should resolve with an error`() {
    PinAuthenticationRequestHandler.CALLBACK = null

    val result = pinAuthenticationRequestAcceptUseCase("12345").exceptionOrNull()
    SdkErrorAssert.assertEquals(AUTHENTICATION_NOT_IN_PROGRESS, result)
  }

  @Test
  fun `When a pin registration callback is set, Then it should resolve successfully`() {
    PinAuthenticationRequestHandler.CALLBACK = oneginiPinCallbackMock

    val result = pinAuthenticationRequestAcceptUseCase("12345").getOrNull()
    Assert.assertEquals(Unit, result)
  }
}
