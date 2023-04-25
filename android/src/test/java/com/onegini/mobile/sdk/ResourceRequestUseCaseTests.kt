package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.android.client.UserClient
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.UNEXPECTED_ERROR_TYPE
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.pigeonPlugin.FlutterError
import com.onegini.mobile.sdk.flutter.pigeonPlugin.HttpRequestMethod.GET
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWRequestDetails
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWRequestResponse
import com.onegini.mobile.sdk.flutter.pigeonPlugin.ResourceRequestType
import com.onegini.mobile.sdk.flutter.useCases.ResourceRequestUseCase
import okhttp3.Callback
import okhttp3.Headers
import okhttp3.Response
import org.mockito.kotlin.any
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.HTTP_REQUEST_ERROR_CODE
import okhttp3.OkHttpClient
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Answers
import org.mockito.Mock
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.argumentCaptor
import org.mockito.kotlin.times
import org.mockito.kotlin.verify
import org.mockito.kotlin.whenever

@RunWith(MockitoJUnitRunner::class)
class ResourceRequestUseCaseTests {
  @Mock(answer = Answers.RETURNS_DEEP_STUBS)
  lateinit var oneginiSdk: OneginiSDK

  @Mock
  lateinit var userClient: UserClient

  @Mock
  lateinit var resourceOkHttpClientMock: OkHttpClient

  @Mock
  lateinit var okhttp3CallMock: okhttp3.Call

  @Mock(answer = Answers.RETURNS_DEEP_STUBS)
  lateinit var responseMock: Response

  @Mock
  lateinit var callbackMock: (Result<OWRequestResponse>) -> Unit

  private lateinit var resourceRequestUseCase: ResourceRequestUseCase

  @Before
  fun attach() {
    resourceRequestUseCase = ResourceRequestUseCase(oneginiSdk)

    whenever(oneginiSdk.oneginiClient.userClient.resourceOkHttpClient).thenReturn(resourceOkHttpClientMock)
    whenever(oneginiSdk.oneginiClient.userClient.implicitResourceOkHttpClient).thenReturn(resourceOkHttpClientMock)
    whenever(oneginiSdk.oneginiClient.deviceClient.anonymousResourceOkHttpClient).thenReturn(resourceOkHttpClientMock)
    whenever(oneginiSdk.oneginiClient.deviceClient.unauthenticatedResourceOkHttpClient).thenReturn(resourceOkHttpClientMock)

    whenever(oneginiSdk.oneginiClient.configModel.resourceBaseUrl).thenReturn("https://token-mobile.test.onegini.com/resources/")
  }

  @Test
  fun `When a successful http response is send, Then the call should resolve with an OWRequestResponse containing correct information`() {
    setupSuccessFullResponseMock()
    whenever(resourceOkHttpClientMock.newCall(any())).thenReturn(okhttp3CallMock)
    argumentCaptor<Callback> {
      whenever(
        okhttp3CallMock.enqueue(capture())
      ).thenAnswer {
        firstValue.onResponse(okhttp3CallMock, responseMock)
      }
    }

    resourceRequestUseCase(ResourceRequestType.IMPLICIT, OWRequestDetails("TEST", GET), callbackMock)

    argumentCaptor<Result<OWRequestResponse>>().apply {
      verify(callbackMock, times(1)).invoke(capture())

      val expectedResponse = OWRequestResponse(mapOf("headerKey" to "headerValue"), "responseBody", true, 200)
      Assert.assertEquals(firstValue.getOrNull(), expectedResponse)
    }
  }

  @Test
  fun `When a successful http response is send but with an error http code, Then the call should resolve with an flutter error`() {
    setupErrorFullResponseMock()
    whenever(resourceOkHttpClientMock.newCall(any())).thenReturn(okhttp3CallMock)
    argumentCaptor<Callback> {
      whenever(
        okhttp3CallMock.enqueue(capture())
      ).thenAnswer {
        firstValue.onResponse(okhttp3CallMock, responseMock)
      }
    }

    resourceRequestUseCase(ResourceRequestType.IMPLICIT, OWRequestDetails("TEST", GET), callbackMock)

    argumentCaptor<Result<OWRequestResponse>>().apply {
      verify(callbackMock, times(1)).invoke(capture())

      when (val error = firstValue.exceptionOrNull()) {
        is FlutterError -> {
          Assert.assertEquals(error.code.toInt(), HTTP_REQUEST_ERROR_CODE.code)
          Assert.assertEquals(error.message, HTTP_REQUEST_ERROR_CODE.message)
          Assert.assertEquals(((error.details as Map<*, *>).toMap()["response"] as Map<*, *>)["statusCode"], "400")
        }
        else -> Assert.fail(UNEXPECTED_ERROR_TYPE.message)
      }
    }
  }

  private fun setupSuccessFullResponseMock() {
    whenever(responseMock.code).thenReturn(200)
    whenever(responseMock.isSuccessful).thenReturn(true)
    whenever(responseMock.body?.string()).thenReturn("responseBody")
    val headers = Headers.Builder().add("headerKey", "headerValue").build()
    whenever(responseMock.headers).thenReturn(headers)
  }

  private fun setupErrorFullResponseMock() {
    whenever(responseMock.code).thenReturn(400)
    val headers = Headers.Builder().add("headerKey", "headerValue").build()
    whenever(responseMock.headers).thenReturn(headers)
  }
}
