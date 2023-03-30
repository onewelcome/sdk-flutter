package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiPinCallback
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.SdkErrorAssert
import com.onegini.mobile.sdk.flutter.handlers.PinRequestHandler
import com.onegini.mobile.sdk.flutter.pigeonPlugin.NativeCallFlutterApi
import com.onegini.mobile.sdk.flutter.useCases.PinRegistrationRequestDenyUseCase
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Mock
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.verify

@RunWith(MockitoJUnitRunner::class)
class PinRegistrationRequestDenyUseCaseTest {

  @Mock
  lateinit var oneginiPinCallbackMock: OneginiPinCallback

  @Mock
  lateinit var callbackMock: (Result<Unit>) -> Unit

  @Mock
  lateinit var nativeApi: NativeCallFlutterApi

  @Mock
  lateinit var oneginiPinCallback: OneginiPinCallback

  lateinit var pinRegistrationRequestDenyUseCase: PinRegistrationRequestDenyUseCase

  lateinit var pinRequestHandler: PinRequestHandler

  @Before
  fun attach() {
    pinRequestHandler = PinRequestHandler(nativeApi)
    pinRegistrationRequestDenyUseCase = PinRegistrationRequestDenyUseCase(pinRequestHandler)
  }

  @Test
  fun `When no pin registration callback is set, Then it should resolve with an error`() {
    val result = pinRegistrationRequestDenyUseCase().exceptionOrNull()
    SdkErrorAssert.assertEquals(PIN_CREATION_NOT_IN_PROGRESS, result)
  }

  @Test
  fun `When a pin registration callback is set, Then it should resolve successfully`() {
    WhenPinCreationStarted()

    val result = pinRegistrationRequestDenyUseCase().getOrNull()
    Assert.assertEquals(Unit, result)
  }

  @Test
  fun `When a pin registration callback is set, Then it should call deny on the sdk callback`() {
    WhenPinCreationStarted()

    pinRegistrationRequestDenyUseCase()

    verify(oneginiPinCallback).denyAuthenticationRequest()
  }


  private fun WhenPinCreationStarted() {
    // Since we Mock the SDK we need to call the startPinCreation ourselves on the CreatePinRequestHandler
    pinRequestHandler.startPinCreation(UserProfile("123456"), oneginiPinCallback, 5)
  }
}
