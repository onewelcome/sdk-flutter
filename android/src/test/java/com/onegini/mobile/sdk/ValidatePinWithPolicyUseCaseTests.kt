package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.handlers.OneginiPinValidationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiPinValidationError
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.useCases.ValidatePinWithPolicyUseCase
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Answers
import org.mockito.Mock
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.any
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
    lateinit var callMock: MethodCall

    @Mock
    lateinit var resultMock: MethodChannel.Result

    lateinit var validatePinWithPolicyUseCase: ValidatePinWithPolicyUseCase

    @Before
    fun attach() {
        validatePinWithPolicyUseCase = ValidatePinWithPolicyUseCase(oneginiSdk)
    }


    @Test
    fun `When supplying null as pin, Then should reject with ARGUMENT_NOT_CORRECT error`() {
        whenever(callMock.argument<String>("pin")).thenReturn(null)

        validatePinWithPolicyUseCase(callMock, resultMock)

        val message = ARGUMENT_NOT_CORRECT.message + " pin is null"
        verify(resultMock).error(eq(ARGUMENT_NOT_CORRECT.code.toString()), eq(message), any())
    }

    @Test
    fun `When pin is not null should call validatePinWithPolicy on the onegini sdk`() {
        whenever(callMock.argument<String>("pin")).thenReturn("14789")

        validatePinWithPolicyUseCase(callMock, resultMock)

        verify(oneginiSdk.oneginiClient.userClient).validatePinWithPolicy(eq("14789".toCharArray()), any())
    }

    @Test
    fun `When oginini validatePinWithPolicy calls onSuccess on the handler, promise should resolve with null`() {
        whenever(callMock.argument<String>("pin")).thenReturn("14789")
        whenever(oneginiSdk.oneginiClient.userClient.validatePinWithPolicy(any(), any())).thenAnswer {
            it.getArgument<OneginiPinValidationHandler>(1).onSuccess()
        }

        validatePinWithPolicyUseCase(callMock, resultMock)

        verify(resultMock).success(null)
    }

    @Test
    fun `When oginini validatePinWithPolicy calls onError on the handler, promise should reject with error from native sdk`() {
        whenever(callMock.argument<String>("pin")).thenReturn("14789")
        whenPinValidationReturnedError()

        validatePinWithPolicyUseCase(callMock, resultMock)

        val message = oneginiPinValidationErrorMock.message
        verify(resultMock).error(eq(oneginiPinValidationErrorMock.errorType.toString()), eq(message), any())
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
