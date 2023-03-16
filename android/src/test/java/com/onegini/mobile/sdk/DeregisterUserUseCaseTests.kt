package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.android.handlers.OneginiDeregisterUserProfileHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiDeregistrationError
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.SdkErrorAssert
import com.onegini.mobile.sdk.flutter.pigeonPlugin.FlutterError
import com.onegini.mobile.sdk.flutter.useCases.DeregisterUserUseCase
import com.onegini.mobile.sdk.flutter.useCases.GetUserProfileUseCase
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
class DeregisterUserUseCaseTests {

  @Mock(answer = Answers.RETURNS_DEEP_STUBS)
  lateinit var oneginiSdk: OneginiSDK

  @Mock
  lateinit var oneginiDeregistrationErrorMock: OneginiDeregistrationError

  @Mock
  lateinit var callbackMock: (Result<Unit>) -> Unit

  lateinit var deregisterUserUseCase: DeregisterUserUseCase

  @Before
  fun attach() {
    val getUserProfileUseCase = GetUserProfileUseCase(oneginiSdk)
    deregisterUserUseCase = DeregisterUserUseCase(oneginiSdk, getUserProfileUseCase)
  }

  @Test
  fun `When the user is not recognised, Then it should return error`() {
    whenever(oneginiSdk.oneginiClient.userClient.userProfiles).thenReturn(setOf(UserProfile("QWERTY")))

    deregisterUserUseCase("ABCDEF", callbackMock)

    argumentCaptor<Result<Unit>>().apply {
      verify(callbackMock).invoke(capture())
      SdkErrorAssert.assertEquals(USER_PROFILE_DOES_NOT_EXIST, firstValue.exceptionOrNull())
    }
  }

  @Test
  fun `When user deregisters successfully, Then it should resolve successfully`() {
    whenever(oneginiSdk.oneginiClient.userClient.userProfiles).thenReturn(setOf(UserProfile("QWERTY")))

    whenever(oneginiSdk.oneginiClient.userClient.deregisterUser(eq(UserProfile("QWERTY")), any())).thenAnswer {
      it.getArgument<OneginiDeregisterUserProfileHandler>(1).onSuccess()
    }

    deregisterUserUseCase("QWERTY", callbackMock)

    argumentCaptor<Result<Unit>>().apply {
      verify(callbackMock).invoke(capture())
      Assert.assertEquals(firstValue.getOrNull(), Unit)
    }
  }

  @Test
  fun `When deregister method return an error, Then the wrapper function should return error`() {
    whenever(oneginiSdk.oneginiClient.userClient.userProfiles).thenReturn(setOf(UserProfile("QWERTY")))
    whenever(oneginiSdk.oneginiClient.userClient.deregisterUser(eq(UserProfile("QWERTY")), any())).thenAnswer {
      it.getArgument<OneginiDeregisterUserProfileHandler>(1).onError(oneginiDeregistrationErrorMock)
    }
    whenever(oneginiDeregistrationErrorMock.errorType).thenReturn(OneginiDeregistrationError.GENERAL_ERROR)
    whenever(oneginiDeregistrationErrorMock.message).thenReturn("General error")

    deregisterUserUseCase("QWERTY", callbackMock)

    argumentCaptor<Result<Unit>>().apply {
      verify(callbackMock).invoke(capture())

      val expected = FlutterError(oneginiDeregistrationErrorMock.errorType.toString(), oneginiDeregistrationErrorMock.message)
      SdkErrorAssert.assertEquals(expected, firstValue.exceptionOrNull())
    }
  }
}
