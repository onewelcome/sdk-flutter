package com.onegini.mobile.sdk

import com.google.common.truth.Truth
import com.onegini.mobile.sdk.android.client.DeviceClient
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.client.UserClient
import com.onegini.mobile.sdk.android.handlers.error.OneginiImplicitTokenRequestError
import com.onegini.mobile.sdk.android.model.OneginiClientConfigModel
import com.onegini.mobile.sdk.flutter.helpers.ResourceHelper
import com.onegini.mobile.sdk.flutter.useCases.GetImplicitResourceUseCase
import com.onegini.mobile.sdk.flutter.useCases.GetUnauthenticatedResourceUseCase
import com.onegini.mobile.sdk.utils.RxSchedulerRule
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import okhttp3.*
import org.junit.Before
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Mock
import org.mockito.Mockito
import org.mockito.Spy
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.argumentCaptor
import org.mockito.kotlin.eq
import org.mockito.kotlin.whenever
import java.util.HashMap

@RunWith(MockitoJUnitRunner::class)
class GetUnauthenticatedResourceUseCaseTests {
    @get:Rule
    val schedulerRule = RxSchedulerRule()

    @Mock
    lateinit var clientMock: OneginiClient

    @Mock
    lateinit var deviceClient: DeviceClient

    @Mock
    lateinit var callMock: MethodCall

    @Mock
    lateinit var configModelMock : OneginiClientConfigModel

    @Mock
    lateinit var unauthenticatedResourceOkHttpClient: OkHttpClient

    @Spy
    lateinit var resultSpy: MethodChannel.Result

    @Spy
    lateinit var resourceHelper: ResourceHelper

    @Before
    fun attach() {
        whenever(clientMock.deviceClient).thenReturn(deviceClient)
        whenever(deviceClient.unauthenticatedResourceOkHttpClient).thenReturn(unauthenticatedResourceOkHttpClient)
        whenever(clientMock.configModel).thenReturn(configModelMock)
        whenever(configModelMock.resourceBaseUrl).thenReturn("https://token-mobile.test.onegini.com/resources/")
    }

    @Test
    fun `should build correct url when 'path' parameter is given`(){
        whenever(callMock.argument<String>("path")).thenReturn("test")

        GetUnauthenticatedResourceUseCase(clientMock)(callMock, resultSpy,resourceHelper)

        argumentCaptor<Request> {
            Mockito.verify(resourceHelper).callRequest(eq(unauthenticatedResourceOkHttpClient), capture(), eq(resultSpy))
            Truth.assertThat(firstValue.url().host()).isEqualTo("token-mobile.test.onegini.com")
            Truth.assertThat(firstValue.url().toString()).isEqualTo("https://token-mobile.test.onegini.com/resources/test")

        }
    }

    @Test
    fun `should build correct headers when 'headers' parameter is given`(){
        whenever(callMock.argument<String>("path")).thenReturn("test")
        whenever(callMock.argument<HashMap<String, String>>("headers")).thenReturn(hashMapOf(Pair("key1","value1"),Pair("key2","value2")))

        GetUnauthenticatedResourceUseCase(clientMock)(callMock, resultSpy,resourceHelper)

        argumentCaptor<Request> {
            Mockito.verify(resourceHelper).callRequest(eq(unauthenticatedResourceOkHttpClient), capture(), eq(resultSpy))
            Truth.assertThat(firstValue.headers()).isEqualTo(Headers.of(mapOf(Pair("key1","value1"),Pair("key2","value2"))))
        }
    }

    @Test
    fun `should build correct method and body when 'method' and 'body' parameter is given`(){
        whenever(callMock.argument<String>("path")).thenReturn("test")
        whenever(callMock.argument<String>("body")).thenReturn("test body")
        whenever(callMock.argument<String>("method")).thenReturn("POST")

        GetUnauthenticatedResourceUseCase(clientMock)(callMock, resultSpy,resourceHelper)

        argumentCaptor<Request> {
            Mockito.verify(resourceHelper).callRequest(eq(unauthenticatedResourceOkHttpClient), capture(), eq(resultSpy))
            Truth.assertThat(firstValue.method()).isEqualTo("POST")
            Truth.assertThat(firstValue.body()?.contentType()?.type()).isEqualTo("application")
            Truth.assertThat(firstValue.body()?.contentType()?.subtype()).isEqualTo("json")
            Truth.assertThat(firstValue.body()?.contentLength()).isEqualTo(RequestBody.create(MediaType.parse("application/json"), "test body").contentLength())
        }
    }

    @Test
    fun `should build correct parameters when 'parameters' parameter is given`(){
        whenever(callMock.argument<String>("path")).thenReturn("test")
        whenever(callMock.argument<HashMap<String, String>>("parameters")).thenReturn(hashMapOf(Pair("key1","value1"),Pair("key2","value2")))

        GetUnauthenticatedResourceUseCase(clientMock)(callMock, resultSpy,resourceHelper)

        argumentCaptor<Request> {
            Mockito.verify(resourceHelper).callRequest(eq(unauthenticatedResourceOkHttpClient), capture(), eq(resultSpy))
            Truth.assertThat(firstValue.url().toString()).isEqualTo("https://token-mobile.test.onegini.com/resources/test?key1=value1&key2=value2")
            Truth.assertThat(firstValue.url().queryParameterNames()).isEqualTo(setOf("key1","key2"))
            Truth.assertThat(firstValue.url().queryParameterValues("key1")).isEqualTo(listOf("value1"))
            Truth.assertThat(firstValue.url().queryParameterValues("key2")).isEqualTo(listOf("value2"))
        }
    }

}