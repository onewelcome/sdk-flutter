package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.android.handlers.OneginiLogoutHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiLogoutError
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.SdkErrorAssert
import com.onegini.mobile.sdk.flutter.pigeonPlugin.FlutterError
import com.onegini.mobile.sdk.flutter.useCases.LogoutUseCase
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Answers
import org.mockito.Mock
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.any
import org.mockito.kotlin.argumentCaptor
import org.mockito.kotlin.verify
import org.mockito.kotlin.whenever
import org.robolectric.util.ReflectionHelpers

@RunWith(MockitoJUnitRunner::class)
class LogoutUseCaseTests {
  @Mock(answer = Answers.RETURNS_DEEP_STUBS)
  lateinit var oneginiSdk: OneginiSDK

  @Mock
  lateinit var oneginiLogoutError: OneginiLogoutError

  @Mock
  lateinit var callbackMock: (Result<Unit>) -> Unit

  lateinit var logoutUseCase: LogoutUseCase

  @Before
  fun attach() {
    logoutUseCase = LogoutUseCase(oneginiSdk)
  }

  @Test
  fun `When SDK return success, Then it should resolve successfully`() {
    whenever(oneginiSdk.oneginiClient.userClient.logout(any())).thenAnswer {
      it.getArgument<OneginiLogoutHandler>(0).onSuccess()
    }

    logoutUseCase(callbackMock)

    argumentCaptor<Result<Unit>>().apply {
      verify(callbackMock).invoke(capture())
      Assert.assertEquals(firstValue.getOrNull(), Unit)
    }
  }

  @Test
  fun `When the SDK returns an error, Then it should return the same error`() {
    ReflectionHelpers.setField(oneginiLogoutError, "errorType", OneginiLogoutError.GENERAL_ERROR);
    whenever(oneginiLogoutError.message).thenReturn("General error")
    whenever(oneginiSdk.oneginiClient.userClient.logout(any())).thenAnswer {
      it.getArgument<OneginiLogoutHandler>(0).onError(oneginiLogoutError)
    }

    logoutUseCase(callbackMock)

    argumentCaptor<Result<Unit>>().apply {
      verify(callbackMock).invoke(capture())

      val expected = FlutterError(oneginiLogoutError.errorType.toString(), oneginiLogoutError.message)
      SdkErrorAssert.assertEquals(expected, firstValue.exceptionOrNull())
    }
  }
}
