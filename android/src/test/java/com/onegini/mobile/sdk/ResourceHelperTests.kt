package com.onegini.mobile.sdk

import com.google.common.truth.Truth
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.helpers.ResourceHelper
import com.onegini.mobile.sdk.utils.RxSchedulerRule
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import okhttp3.Headers.Companion.toHeaders
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.RequestBody.Companion.toRequestBody
import org.junit.Before
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Answers
import org.mockito.Mock
import org.mockito.Spy
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.whenever

@RunWith(MockitoJUnitRunner::class)
class ResourceHelperTests {

    @Mock(answer = Answers.RETURNS_DEEP_STUBS)
    lateinit var oneginiSdk: OneginiSDK

    @get:Rule
    val schedulerRule = RxSchedulerRule()

    @Mock
    lateinit var clientMock: OneginiClient
    @Mock
    lateinit var callMock: MethodCall

    lateinit var resourceHelper: ResourceHelper

    @Before
    fun setup() {
//        resourceHelper = ResourceHelper()
    }
    @Test
    fun `should build correct url when 'path' parameter is given`() {
        whenever(callMock.argument<String>("path")).thenReturn("test")

        val request = resourceHelper.getRequest(callMock, "https://token-mobile.test.onegini.com/resources/")

        Truth.assertThat(request.url.host).isEqualTo("token-mobile.test.onegini.com")
        Truth.assertThat(request.url.toString()).isEqualTo("https://token-mobile.test.onegini.com/resources/test")
    }

    @Test
    fun `should build correct url with headers when 'headers' parameter is given`() {
        whenever(callMock.argument<String>("path")).thenReturn("test")
        whenever(callMock.argument<HashMap<String, String>>("headers")).thenReturn(hashMapOf(Pair("key1", "value1"), Pair("key2", "value2")))

        val request = resourceHelper.getRequest(callMock, "https://token-mobile.test.onegini.com/resources/")

        Truth.assertThat(request.headers).isEqualTo(mapOf(Pair("key1", "value1"), Pair("key2", "value2")).toHeaders())
    }

    @Test
    fun `should build correct method and body when 'method' and 'body' parameter is given`() {
        whenever(callMock.argument<String>("path")).thenReturn("test")
        whenever(callMock.argument<String>("body")).thenReturn("test body")
        whenever(callMock.argument<String>("method")).thenReturn("POST")

        val request = resourceHelper.getRequest(callMock, "https://token-mobile.test.onegini.com/resources/")

        Truth.assertThat(request.method).isEqualTo("POST")
        Truth.assertThat(request.body?.contentType()?.type).isEqualTo("application")
        Truth.assertThat(request.body?.contentType()?.subtype).isEqualTo("json")
        Truth.assertThat(request.body?.contentLength()).isEqualTo("test body".toRequestBody("application/json".toMediaTypeOrNull()).contentLength())
    }

    @Test
    fun `should build correct parameters when 'parameters' parameter is given`() {
        whenever(callMock.argument<String>("path")).thenReturn("test")
        whenever(callMock.argument<HashMap<String, String>>("parameters")).thenReturn(hashMapOf(Pair("key1", "value1"), Pair("key2", "value2")))

        val request = resourceHelper.getRequest(callMock, "https://token-mobile.test.onegini.com/resources/")

        Truth.assertThat(request.url.toString()).isEqualTo("https://token-mobile.test.onegini.com/resources/test?key1=value1&key2=value2")
        Truth.assertThat(request.url.queryParameterNames).isEqualTo(setOf("key1", "key2"))
        Truth.assertThat(request.url.queryParameterValues("key1")).isEqualTo(listOf("value1"))
        Truth.assertThat(request.url.queryParameterValues("key2")).isEqualTo(listOf("value2"))
    }
}