package com.onegini.mobile.sdk

import com.google.common.truth.Truth
import com.onegini.mobile.sdk.android.handlers.OneginiDeviceAuthenticationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiDeviceAuthenticationError
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.SdkErrorAssert
import com.onegini.mobile.sdk.flutter.pigeonPlugin.FlutterError
import com.onegini.mobile.sdk.flutter.useCases.AuthenticateDeviceUseCase
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Answers
import org.mockito.ArgumentMatchers
import org.mockito.Mock
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.any
import org.mockito.kotlin.argumentCaptor
import org.mockito.kotlin.eq
import org.mockito.kotlin.isNull
import org.mockito.kotlin.verify
import org.mockito.kotlin.whenever

@RunWith(MockitoJUnitRunner::class)
class AuthenticateDeviceUseCaseTests {

  @Mock(answer = Answers.RETURNS_DEEP_STUBS)
  lateinit var oneginiSdk: OneginiSDK

  @Mock
  lateinit var oneginiDeviceAuthenticationErrorMock: OneginiDeviceAuthenticationError

  @Mock
  lateinit var callbackMock: (Result<Unit>) -> Unit

  lateinit var authenticateDeviceUseCase: AuthenticateDeviceUseCase

  @Before
  fun attach() {
    authenticateDeviceUseCase = AuthenticateDeviceUseCase(oneginiSdk)
  }

  @Test
  fun `When the sdk returns an Authentication error, Then it should resolve with an error`() {
    whenever(oneginiDeviceAuthenticationErrorMock.errorType).thenReturn(OneginiDeviceAuthenticationError.GENERAL_ERROR)
    whenever(oneginiDeviceAuthenticationErrorMock.message).thenReturn("General error")
    whenever(oneginiSdk.oneginiClient.deviceClient.authenticateDevice(isNull(), any())).thenAnswer {
      it.getArgument<OneginiDeviceAuthenticationHandler>(1).onError(oneginiDeviceAuthenticationErrorMock)
    }
    authenticateDeviceUseCase(null, callbackMock)

    argumentCaptor<Result<Unit>>().apply {
      verify(callbackMock).invoke(capture())

      val expected = FlutterError(OneginiDeviceAuthenticationError.GENERAL_ERROR.toString(), "General error")
      SdkErrorAssert.assertEquals(expected, firstValue.exceptionOrNull())
    }
  }

  @Test
  fun `When the authentications goes successful, Then it should return resolve successfully`() {
    whenever(oneginiSdk.oneginiClient.deviceClient.authenticateDevice(eq(arrayOf("test")), any())).thenAnswer {
      it.getArgument<OneginiDeviceAuthenticationHandler>(1).onSuccess()
    }

    authenticateDeviceUseCase(listOf("test"), callbackMock)

    argumentCaptor<Result<Unit>>().apply {
      verify(callbackMock).invoke(capture())
      Assert.assertEquals(firstValue.getOrNull(), Unit)
    }
  }

  @Test
  fun `When two scopes are passed, Then the native sdk should also respond with two scopes`() {
    authenticateDeviceUseCase(listOf("read", "write"), callbackMock)

    argumentCaptor<Array<String>>().apply {
      verify(oneginiSdk.oneginiClient.deviceClient).authenticateDevice(capture(), ArgumentMatchers.any())
      Truth.assertThat(firstValue.size).isEqualTo(2)
      Truth.assertThat(firstValue).isEqualTo(arrayOf("read", "write"))
    }
  }
}
