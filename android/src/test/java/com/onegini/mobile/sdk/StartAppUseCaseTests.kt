package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.android.handlers.OneginiInitializationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiInitializationError
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.SdkErrorAssert
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import com.onegini.mobile.sdk.flutter.pigeonPlugin.FlutterError
import com.onegini.mobile.sdk.flutter.useCases.StartAppUseCase
import org.junit.Assert.assertEquals
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Answers
import org.mockito.Mock
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.*
import org.robolectric.util.ReflectionHelpers

@RunWith(MockitoJUnitRunner::class)
class StartAppUseCaseTests {
  @Mock(answer = Answers.RETURNS_DEEP_STUBS)
  lateinit var oneginiSdk: OneginiSDK

  @Mock
  lateinit var callbackMock: (Result<Unit>) -> Unit

  @Mock
  lateinit var oneginiInitializationError: OneginiInitializationError

  private lateinit var startAppUseCase: StartAppUseCase

  @Before
  fun attach() {
    startAppUseCase = StartAppUseCase(oneginiSdk)
  }

  private val errorCode = OneginiInitializationError.GENERAL_ERROR
  private val errorMessage = "General error"

  @Test
  fun `When onError gets called by oneginiClient, Then should call callback with Result_failure with that error`() {
    whenCallsOnError()

    startAppUseCase(
      null,
      null,
      null,
      null,
      null,
      callbackMock
    )

    argumentCaptor<Result<Unit>>().apply {
      verify(callbackMock).invoke(capture())
      val expected = FlutterError(oneginiInitializationError.errorType.toString(), oneginiInitializationError.message)
      SdkErrorAssert.assertEquals(expected, firstValue.exceptionOrNull())
    }
  }

  @Test
  fun `When onSuccess gets called by oneginiClient, Then should call callback with Result_success`() {
    whenCallsOnSuccess()

    startAppUseCase(
      null,
      null,
      null,
      null,
      null,
      callbackMock
    )

    argumentCaptor<Result<Unit>>().apply {
      verify(callbackMock).invoke(capture())
      assertEquals(firstValue.isSuccess, true)
    }
  }

  @Test
  fun `When OneginiSDK_buildSDK throws an exception Then we should reject with that error`() {
    whenBuildSdkThrowsSdkError()

    startAppUseCase(
      null,
      null,
      null,
      null,
      null,
      callbackMock
    )

    argumentCaptor<Result<Unit>>().apply {
      verify(callbackMock).invoke(capture())
      val expected = FlutterError(errorCode.toString(), errorMessage)
      SdkErrorAssert.assertEquals(expected, firstValue.exceptionOrNull())
    }
  }

  private fun whenCallsOnError() {
    whenever(oneginiSdk.oneginiClient.start(any())).thenAnswer {
      it.getArgument<OneginiInitializationHandler>(0).onError(oneginiInitializationError)
    }
    ReflectionHelpers.setField(oneginiInitializationError, "errorType", errorCode);
    whenever(oneginiInitializationError.message).thenReturn(errorMessage)
  }

  private fun whenBuildSdkThrowsSdkError() {
    whenever(oneginiSdk.buildSDK(anyOrNull(), anyOrNull(), anyOrNull(), anyOrNull(), anyOrNull())).thenAnswer {
      throw SdkError(
        code = errorCode,
        message = errorMessage
      )
    }
  }

  private fun whenCallsOnSuccess() {
    whenever(oneginiSdk.oneginiClient.start(any())).thenAnswer {
      it.getArgument<OneginiInitializationHandler>(0).onSuccess(emptySet())
    }
  }
}
