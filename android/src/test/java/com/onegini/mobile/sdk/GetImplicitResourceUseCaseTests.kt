package com.onegini.mobile.sdk

import com.google.common.truth.Truth
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.client.UserClient
import com.onegini.mobile.sdk.android.model.OneginiClientConfigModel
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.UNAUTHENTICATED_IMPLICITLY
import com.onegini.mobile.sdk.flutter.helpers.ResourceHelper
import com.onegini.mobile.sdk.flutter.useCases.GetImplicitResourceUseCase
import com.onegini.mobile.sdk.utils.RxSchedulerRule
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import okhttp3.OkHttpClient
import okhttp3.Request
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
import org.mockito.kotlin.verify
import org.mockito.kotlin.whenever

@RunWith(MockitoJUnitRunner::class)
class GetImplicitResourceUseCaseTests {

    @get:Rule
    val schedulerRule = RxSchedulerRule()

    @Mock
    lateinit var clientMock: OneginiClient

    @Mock
    lateinit var userClientMock: UserClient

    @Mock
    lateinit var callMock: MethodCall

    @Mock
    lateinit var configModelMock: OneginiClientConfigModel

    @Mock
    lateinit var implicitResourceOkHttpClientMock: OkHttpClient

    @Mock
    lateinit var requestMock: Request

    @Spy
    lateinit var resultSpy: MethodChannel.Result

    @Mock
    lateinit var resourceHelper: ResourceHelper

    @Before
    fun attach() {
        whenever(clientMock.userClient).thenReturn(userClientMock)
        whenever(userClientMock.implicitResourceOkHttpClient).thenReturn(implicitResourceOkHttpClientMock)
        whenever(clientMock.configModel).thenReturn(configModelMock)
        whenever(configModelMock.resourceBaseUrl).thenReturn("https://token-mobile.test.onegini.com/resources/")
    }

    @Test
    fun `should return error when the user is not implicitly authenticated`() {
        GetImplicitResourceUseCase(clientMock)(callMock, resultSpy, resourceHelper)

        verify(resultSpy).error(
            UNAUTHENTICATED_IMPLICITLY.code.toString(), UNAUTHENTICATED_IMPLICITLY.message,
            mutableMapOf("code" to UNAUTHENTICATED_IMPLICITLY.code.toString(), "message" to UNAUTHENTICATED_IMPLICITLY.message)
        )
    }

    @Test
    fun `should call getRequest with correct params`() {
        whenever(userClientMock.implicitlyAuthenticatedUserProfile).thenReturn(UserProfile("QWERTY"))

        GetImplicitResourceUseCase(clientMock)(callMock, resultSpy, resourceHelper)

        verify(resourceHelper).getRequest(callMock, "https://token-mobile.test.onegini.com/resources/")
    }

    @Test
    fun `should call request with correct HTTP client`() {
        whenever(resourceHelper.getRequest(callMock, "https://token-mobile.test.onegini.com/resources/")).thenReturn(requestMock)
        whenever(userClientMock.implicitlyAuthenticatedUserProfile).thenReturn(UserProfile("QWERTY"))

        GetImplicitResourceUseCase(clientMock)(callMock, resultSpy, resourceHelper)


        argumentCaptor<OkHttpClient> {
            Mockito.verify(resourceHelper).callRequest(capture(), eq(requestMock), eq(resultSpy))
            Truth.assertThat(firstValue).isEqualTo(implicitResourceOkHttpClientMock)
        }
    }
}
