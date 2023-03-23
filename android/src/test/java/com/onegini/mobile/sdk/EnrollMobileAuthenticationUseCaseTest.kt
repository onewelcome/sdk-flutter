package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.android.handlers.OneginiMobileAuthEnrollmentHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiMobileAuthEnrollmentError
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.NO_USER_PROFILE_IS_AUTHENTICATED
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.SdkErrorAssert
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import com.onegini.mobile.sdk.flutter.pigeonPlugin.FlutterError
import com.onegini.mobile.sdk.flutter.useCases.EnrollMobileAuthenticationUseCase
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

@RunWith(MockitoJUnitRunner::class)
class EnrollMobileAuthenticationUseCaseTest {
  @Mock(answer = Answers.RETURNS_DEEP_STUBS)
  lateinit var oneginiSdk: OneginiSDK

  @Mock
  lateinit var enrollErrorMock: OneginiMobileAuthEnrollmentError

  @Mock
  lateinit var callbackMock: (Result<Unit>) -> Unit

  lateinit var enrollMobileAuthenticationUseCase: EnrollMobileAuthenticationUseCase

  @Before
  fun attach() {
    enrollMobileAuthenticationUseCase = EnrollMobileAuthenticationUseCase(oneginiSdk)
    whenever(enrollErrorMock.errorType).thenReturn(OneginiMobileAuthEnrollmentError.GENERAL_ERROR)
    whenever(enrollErrorMock.message).thenReturn("General error")
  }

  @Test
  fun `When there is no authenticated user during the enrollment, Then it should resolve with an error`() {
    whenever(oneginiSdk.oneginiClient.userClient.authenticatedUserProfile).thenReturn(null)

    enrollMobileAuthenticationUseCase(callbackMock)

    argumentCaptor<Result<Unit>>().apply {
      verify(callbackMock).invoke(capture())

      val expected = SdkError(NO_USER_PROFILE_IS_AUTHENTICATED).pigeonError()
      SdkErrorAssert.assertEquals(expected, firstValue.exceptionOrNull())
    }
  }

  @Test
  fun `When the sdk returns an enrollment error, Then it should resolve with an error`() {
    whenever(oneginiSdk.oneginiClient.userClient.authenticatedUserProfile).thenReturn(UserProfile("QWERTY"))
    whenever(oneginiSdk.oneginiClient.userClient.enrollUserForMobileAuth(any())).thenAnswer {
      it.getArgument<OneginiMobileAuthEnrollmentHandler>(0).onError(enrollErrorMock)
    }

    enrollMobileAuthenticationUseCase(callbackMock)

    argumentCaptor<Result<Unit>>().apply {
      verify(callbackMock).invoke(capture())

      val expected = FlutterError(OneginiMobileAuthEnrollmentError.GENERAL_ERROR.toString(), "General error")
      SdkErrorAssert.assertEquals(expected, firstValue.exceptionOrNull())
    }
  }

  @Test
  fun `When the sdk succeeds with the enrollment, Then it should resolve successfully`() {
    whenever(oneginiSdk.oneginiClient.userClient.authenticatedUserProfile).thenReturn(UserProfile("QWERTY"))
    whenever(oneginiSdk.oneginiClient.userClient.enrollUserForMobileAuth(any())).thenAnswer {
      it.getArgument<OneginiMobileAuthEnrollmentHandler>(0).onSuccess()
    }

    enrollMobileAuthenticationUseCase(callbackMock)

    argumentCaptor<Result<Unit>>().apply {
      verify(callbackMock).invoke(capture())

      Assert.assertEquals(firstValue.getOrNull(), Unit)
    }
  }
}
