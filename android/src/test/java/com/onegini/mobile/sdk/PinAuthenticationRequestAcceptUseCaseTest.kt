package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiPinCallback
import com.onegini.mobile.sdk.android.model.entity.AuthenticationAttemptCounter
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.NOT_IN_PROGRESS_AUTHENTICATION
import com.onegini.mobile.sdk.flutter.SdkErrorAssert
import com.onegini.mobile.sdk.flutter.handlers.PinAuthenticationRequestHandler
import com.onegini.mobile.sdk.flutter.pigeonPlugin.NativeCallFlutterApi
import com.onegini.mobile.sdk.flutter.useCases.PinAuthenticationRequestAcceptUseCase
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Mock
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.verify

@RunWith(MockitoJUnitRunner::class)
class PinAuthenticationRequestAcceptUseCaseTest {
  @Mock
  lateinit var oneginiPinCallbackMock: OneginiPinCallback

  @Mock
  lateinit var callbackMock: (Result<Unit>) -> Unit

  @Mock
  lateinit var nativeApi: NativeCallFlutterApi

  @Mock
  lateinit var authenticationAttemptCounter: AuthenticationAttemptCounter

  private lateinit var pinAuthenticationRequestAcceptUseCase: PinAuthenticationRequestAcceptUseCase

  private lateinit var pinAuthenticationRequestHandler: PinAuthenticationRequestHandler

  @Before
  fun before() {
    pinAuthenticationRequestHandler = PinAuthenticationRequestHandler(nativeApi)
    pinAuthenticationRequestAcceptUseCase = PinAuthenticationRequestAcceptUseCase(pinAuthenticationRequestHandler)
  }

  @Test
  fun `When no pin registration callback is set, Then it should fail with an error`() {
    val result = pinAuthenticationRequestAcceptUseCase("12345").exceptionOrNull()

    SdkErrorAssert.assertEquals(NOT_IN_PROGRESS_AUTHENTICATION, result)
  }

  @Test
  fun `When a pin registration callback is set, Then it should resolve successfully`() {
    whenPinAuthenticationStarted()

    val result = pinAuthenticationRequestAcceptUseCase("12345").getOrNull()

    Assert.assertEquals(Unit, result)
  }

  @Test
  fun `When a pin registration callback is set, Then it should call accept on the sdk callback`() {
    whenPinAuthenticationStarted()

    pinAuthenticationRequestAcceptUseCase("12345")

    verify(oneginiPinCallbackMock).acceptAuthenticationRequest("12345".toCharArray())
  }

  private fun whenPinAuthenticationStarted() {
    // Since we Mock the SDK we need to call the startAuthentication ourselves on the pinAuthenticationRequestHandler
    pinAuthenticationRequestHandler.startAuthentication(UserProfile("123456"), oneginiPinCallbackMock, authenticationAttemptCounter)
  }
}
