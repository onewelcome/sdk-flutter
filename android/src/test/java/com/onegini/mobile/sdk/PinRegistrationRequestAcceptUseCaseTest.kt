package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiPinCallback
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.REGISTRATION_NOT_IN_PROGRESS
import com.onegini.mobile.sdk.flutter.SdkErrorAssert
import com.onegini.mobile.sdk.flutter.handlers.PinRequestHandler
import com.onegini.mobile.sdk.flutter.useCases.PinRegistrationRequestAcceptUseCase
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Mock
import org.mockito.junit.MockitoJUnitRunner

@RunWith(MockitoJUnitRunner::class)
class PinRegistrationRequestAcceptUseCaseTest {

  @Mock
  lateinit var oneginiPinCallbackMock: OneginiPinCallback

  @Mock
  lateinit var callbackMock: (Result<Unit>) -> Unit

  lateinit var pinRegistrationRequestAcceptUseCase: PinRegistrationRequestAcceptUseCase

  @Before
  fun attach() {
    pinRegistrationRequestAcceptUseCase = PinRegistrationRequestAcceptUseCase()
  }

  @Test
  fun `When no pin registration callback is set, Then it should resolve with an error`() {
    PinRequestHandler.callback = null

    val result = pinRegistrationRequestAcceptUseCase("12345").exceptionOrNull()
    SdkErrorAssert.assertEquals(REGISTRATION_NOT_IN_PROGRESS, result)
  }

  @Test
  fun `When a pin registration callback is set, Then it should resolve successfully`() {
    PinRequestHandler.callback = oneginiPinCallbackMock

    val result = pinRegistrationRequestAcceptUseCase("12345").getOrNull()
    Assert.assertEquals(Unit, result)
  }
}
