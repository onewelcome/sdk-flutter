package com.onegini.mobile.sdk

import android.net.Uri
import com.onegini.mobile.sdk.android.handlers.OneginiAppToWebSingleSignOnHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiAppToWebSingleSignOnError
import com.onegini.mobile.sdk.android.model.OneginiAppToWebSingleSignOn
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.SdkErrorAssert
import com.onegini.mobile.sdk.flutter.facade.UriFacade
import com.onegini.mobile.sdk.flutter.pigeonPlugin.FlutterError
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWAppToWebSingleSignOn
import com.onegini.mobile.sdk.flutter.useCases.GetAppToWebSingleSignOnUseCase
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
class GetAppToWebSingleSignOnUseCaseTests {
  @Mock(answer = Answers.RETURNS_DEEP_STUBS)
  lateinit var oneginiSdk: OneginiSDK

  @Mock
  lateinit var callbackMock: (Result<OWAppToWebSingleSignOn>) -> Unit

  @Mock
  private lateinit var uriFacade: UriFacade

  // We need to deep stub here to mock a uri object's .toString() as we cant pass a uriFacade into the OneginiAppToWebSingleSignOn
  @Mock(answer = Answers.RETURNS_DEEP_STUBS)
  private lateinit var oneginiAppToWebSingleSignOn: OneginiAppToWebSingleSignOn

  @Mock
  private lateinit var oneginiAppToWebSingleSignOnError: OneginiAppToWebSingleSignOnError

  @Mock
  private lateinit var parsedUri: Uri

  private val correctUri = "https://login-mobile.test.onegini.com/personal/dashboard"
  private val mockedTokenString = "mockedToken"
  private val mockedRedirectUrlString = "mockedRedirectUrl"

  private lateinit var getAppToWebSingleSignOnUseCase: GetAppToWebSingleSignOnUseCase

  @Before
  fun setup() {
    getAppToWebSingleSignOnUseCase = GetAppToWebSingleSignOnUseCase(oneginiSdk, uriFacade)
  }

  @Test
  fun `When oginini getAppToWebSingleSignOn calls onSuccess on the handler, Then promise should resolve with a OWAppToWebSingleSignOn with the token and url`() {
    mockParseUri(correctUri)
    mockSingleSignOnObject()
    whenever(oneginiSdk.oneginiClient.userClient.getAppToWebSingleSignOn(any(), any())).thenAnswer {
      it.getArgument<OneginiAppToWebSingleSignOnHandler>(1).onSuccess(oneginiAppToWebSingleSignOn)
    }

    getAppToWebSingleSignOnUseCase(correctUri, callbackMock)

    argumentCaptor<Result<OWAppToWebSingleSignOn>>().apply {
      verify(callbackMock).invoke(capture())
      Assert.assertEquals(firstValue.getOrNull()?.token, oneginiAppToWebSingleSignOn.token)
      Assert.assertEquals(firstValue.getOrNull()?.redirectUrl, oneginiAppToWebSingleSignOn.redirectUrl.toString())
    }
  }

  @Test
  fun `When oginini getAppToWebSingleSignOn calls onError on the handler, Then result should fail with the error message and code`() {
    mockParseUri(correctUri)
    whenSSOReturnsError()

    getAppToWebSingleSignOnUseCase(correctUri, callbackMock)

    argumentCaptor<Result<OWAppToWebSingleSignOn>>().apply {
      verify(callbackMock).invoke(capture())
      val expected = FlutterError(oneginiAppToWebSingleSignOnError.errorType.toString(), oneginiAppToWebSingleSignOnError.message)
      SdkErrorAssert.assertEquals(expected, firstValue.exceptionOrNull())
    }
  }

  private fun mockSingleSignOnObject() {
    whenever(oneginiAppToWebSingleSignOn.token).thenReturn(mockedTokenString)
    whenever(oneginiAppToWebSingleSignOn.redirectUrl.toString()).thenReturn(mockedRedirectUrlString)
  }

  private fun whenSSOReturnsError() {
    ReflectionHelpers.setField(oneginiAppToWebSingleSignOnError, "errorType", 1000);
    whenever(oneginiAppToWebSingleSignOnError.message).thenReturn("message")
    whenever(oneginiSdk.oneginiClient.userClient.getAppToWebSingleSignOn(any(), any())).thenAnswer {
      it.getArgument<OneginiAppToWebSingleSignOnHandler>(1).onError(oneginiAppToWebSingleSignOnError)
    }
  }

  private fun mockParseUri(uri: String) {
    whenever(uriFacade.parse(uri)).thenReturn(parsedUri)
  }
}
