package com.onegini.mobile.sdk

import com.google.common.truth.Truth
import com.onegini.mobile.sdk.android.client.DeviceClient
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.model.OneginiClientConfigModel
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.helpers.ResourceHelper
import com.onegini.mobile.sdk.flutter.useCases.GetUnauthenticatedResourceUseCase
import com.onegini.mobile.sdk.utils.RxSchedulerRule
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import okhttp3.OkHttpClient
import okhttp3.Request
import org.junit.Before
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Answers
import org.mockito.Mock
import org.mockito.Mockito
import org.mockito.Spy
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.argumentCaptor
import org.mockito.kotlin.eq
import org.mockito.kotlin.verify
import org.mockito.kotlin.whenever

@RunWith(MockitoJUnitRunner::class)
class GetUnauthenticatedResourceUseCaseTests {

    @Mock(answer = Answers.RETURNS_DEEP_STUBS)
    lateinit var oneginiSdk: OneginiSDK

    @get:Rule
    val schedulerRule = RxSchedulerRule()

    @Mock
    lateinit var clientMock: OneginiClient

    @Mock
    lateinit var deviceClient: DeviceClient

    @Mock
    lateinit var callMock: MethodCall

    @Mock
    lateinit var configModelMock: OneginiClientConfigModel

    @Mock
    lateinit var unauthenticatedResourceOkHttpClient: OkHttpClient

    @Mock
    lateinit var requestMock: Request

    @Spy
    lateinit var resultSpy: MethodChannel.Result

    @Mock
    lateinit var resourceHelper: ResourceHelper

    lateinit var getUnauthenticatedResourceUseCase: GetUnauthenticatedResourceUseCase

    @Before
    fun attach() {
        getUnauthenticatedResourceUseCase = GetUnauthenticatedResourceUseCase(oneginiSdk)
        whenever(oneginiSdk.oneginiClient.deviceClient).thenReturn(deviceClient)
        whenever(deviceClient.unauthenticatedResourceOkHttpClient).thenReturn(unauthenticatedResourceOkHttpClient)
        whenever(oneginiSdk.oneginiClient.configModel).thenReturn(configModelMock)
        whenever(configModelMock.resourceBaseUrl).thenReturn("https://token-mobile.test.onegini.com/resources/")
    }

    @Test
    fun `should call getRequest with correct params`() {
        getUnauthenticatedResourceUseCase(callMock, resultSpy, resourceHelper)

        verify(resourceHelper).getRequest(callMock, "https://token-mobile.test.onegini.com/resources/")
    }

    @Test
    fun `should call request with correct HTTP client`() {
        whenever(resourceHelper.getRequest(callMock, "https://token-mobile.test.onegini.com/resources/")).thenReturn(requestMock)

        getUnauthenticatedResourceUseCase(callMock, resultSpy, resourceHelper)

        argumentCaptor<OkHttpClient> {
            verify(resourceHelper).callRequest(capture(), eq(requestMock), eq(resultSpy))
            Truth.assertThat(firstValue).isEqualTo(unauthenticatedResourceOkHttpClient)
        }
    }

}