package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.handlers.OneginiPinValidationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiPinValidationError
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.SdkErrorAssert
import com.onegini.mobile.sdk.flutter.pigeonPlugin.FlutterError
import com.onegini.mobile.sdk.flutter.useCases.ValidatePinWithPolicyUseCase
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Answers
import org.mockito.Mock
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.any
import org.mockito.kotlin.argumentCaptor
import org.mockito.kotlin.eq
import org.mockito.kotlin.verify
import org.mockito.kotlin.whenever

@RunWith(MockitoJUnitRunner::class)
class ValidatePinWithPolicyUseCaseTests {
  @Mock
  lateinit var oneginiPinValidationErrorMock: OneginiPinValidationError

  @Mock(answer = Answers.RETURNS_DEEP_STUBS)
  lateinit var oneginiSdk: OneginiSDK

  @Mock
  lateinit var clientMock: OneginiClient

  @Mock
  lateinit var callbackMock: (Result<Unit>) -> Unit

  lateinit var validatePinWithPolicyUseCase: ValidatePinWithPolicyUseCase

  @Before
  fun attach() {
    validatePinWithPolicyUseCase = ValidatePinWithPolicyUseCase(oneginiSdk)
  }


  @Test
  fun `When pin is not null, Then it should call validatePinWithPolicy on the onegini sdk`() {
    validatePinWithPolicyUseCase("14789", callbackMock)

    verify(oneginiSdk.oneginiClient.userClient).validatePinWithPolicy(eq("14789".toCharArray()), any())
  }

  @Test
  fun `When oginini validatePinWithPolicy calls onSuccess on the handler, Then the promise should resolve successfully`() {
    whenever(oneginiSdk.oneginiClient.userClient.validatePinWithPolicy(any(), any())).thenAnswer {
      it.getArgument<OneginiPinValidationHandler>(1).onSuccess()
    }

    validatePinWithPolicyUseCase("14789", callbackMock)

    argumentCaptor<Result<Unit>>().apply {
      verify(callbackMock).invoke(capture())
      Assert.assertEquals(firstValue.getOrNull(), Unit)
    }
  }

  @Test
  fun `When oginini validatePinWithPolicy calls onError on the handler, Then the promise should reject with error from native sdk`() {
    whenPinValidationReturnedError()

    validatePinWithPolicyUseCase("14789", callbackMock)

    argumentCaptor<Result<Unit>>().apply {
      verify(callbackMock).invoke(capture())
      val expected = FlutterError(oneginiPinValidationErrorMock.errorType.toString(), oneginiPinValidationErrorMock.message)
      SdkErrorAssert.assertEquals(expected, firstValue.exceptionOrNull())
    }
  }

  private fun whenPinValidationReturnedError() {
    val errorCode = 111
    val errorMessage = "message"
    whenever(oneginiPinValidationErrorMock.errorType).thenReturn(errorCode)
    whenever(oneginiPinValidationErrorMock.message).thenReturn(errorMessage)
    whenever(oneginiSdk.oneginiClient.userClient.validatePinWithPolicy(any(), any())).thenAnswer {
      it.getArgument<OneginiPinValidationHandler>(1).onError(oneginiPinValidationErrorMock)
    }
  }
}
