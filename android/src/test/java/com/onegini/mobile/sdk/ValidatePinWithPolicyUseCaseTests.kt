package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.client.UserClient
import com.onegini.mobile.sdk.android.handlers.OneginiPinValidationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiPinValidationError
import com.onegini.mobile.sdk.flutter.useCases.ValidatePinWithPolicyUseCase
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Mock
import org.mockito.Spy
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.*

@RunWith(MockitoJUnitRunner::class)
class ValidatePinWithPolicyUseCaseTests {
    @Mock
    lateinit var clientMock: OneginiClient

    @Mock
    lateinit var userClientMock: UserClient

    @Mock
    lateinit var oneginiPinValidationError: OneginiPinValidationError

    @Mock
    lateinit var callMock: MethodCall

    @Spy
    lateinit var resultSpy: MethodChannel.Result

    @Before
    fun attach() {
        whenever(clientMock.userClient).thenReturn(userClientMock)
    }


    @Test
    fun `should return error when sdk return error`() {
        whenever(oneginiPinValidationError.errorType).thenReturn(OneginiPinValidationError.GENERAL_ERROR)
        whenever(oneginiPinValidationError.message).thenReturn("General error")
        whenever(userClientMock.validatePinWithPolicy(isNull(), any())).thenAnswer {
            it.getArgument<OneginiPinValidationHandler>(1).onError(oneginiPinValidationError)
        }

        ValidatePinWithPolicyUseCase(clientMock)(callMock, resultSpy)

        verify(resultSpy).error(oneginiPinValidationError.errorType.toString(), oneginiPinValidationError.message, null)
    }

    @Test
    fun `should return true when sdk return success`() {
        whenever(callMock.argument<String>("pin")).thenReturn("12345")
        whenever(userClientMock.validatePinWithPolicy(eq("12345".toCharArray()), any())).thenAnswer {
            it.getArgument<OneginiPinValidationHandler>(1).onSuccess()
        }

        ValidatePinWithPolicyUseCase(clientMock)(callMock, resultSpy)

        verify(resultSpy).success(true)
    }
}