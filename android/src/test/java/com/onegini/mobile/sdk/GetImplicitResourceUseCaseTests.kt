package com.onegini.mobile.sdk

import com.google.common.truth.Truth
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.client.UserClient
import com.onegini.mobile.sdk.android.model.OneginiClientConfigModel
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.USER_NOT_AUTHENTICATED_IMPLICITLY
import com.onegini.mobile.sdk.flutter.OneginiSDK
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
class GetImplicitResourceUseCaseTests {

    @Mock(answer = Answers.RETURNS_DEEP_STUBS)
    lateinit var oneginiSdk: OneginiSDK

    @get:Rule
    val schedulerRule = RxSchedulerRule()

    @Mock
    lateinit var callMock: MethodCall

    @Mock
    lateinit var configModelMock: OneginiClientConfigModel

    @Mock
    lateinit var requestMock: Request

    @Spy
    lateinit var resultSpy: MethodChannel.Result

    @Mock
    lateinit var resourceHelper: ResourceHelper

    lateinit var getImplicitResourceUseCase: GetImplicitResourceUseCase
    @Before
    fun attach() {
        getImplicitResourceUseCase = GetImplicitResourceUseCase(oneginiSdk)
        whenever(oneginiSdk.oneginiClient.configModel.resourceBaseUrl).thenReturn("https://token-mobile.test.onegini.com/resources/")
    }

    @Test
    fun `should return error when the user is not implicitly authenticated`() {
        getImplicitResourceUseCase(callMock, resultSpy, resourceHelper)

        verify(resultSpy).error(
            USER_NOT_AUTHENTICATED_IMPLICITLY.code.toString(), USER_NOT_AUTHENTICATED_IMPLICITLY.message,
            mutableMapOf("code" to USER_NOT_AUTHENTICATED_IMPLICITLY.code.toString(), "message" to USER_NOT_AUTHENTICATED_IMPLICITLY.message)
        )
    }

    @Test
    fun `should call getRequest with correct params`() {
        whenever(oneginiSdk.oneginiClient.userClient.implicitlyAuthenticatedUserProfile).thenReturn(UserProfile("QWERTY"))

        getImplicitResourceUseCase(callMock, resultSpy, resourceHelper)

        verify(resourceHelper).getRequest(callMock, "https://token-mobile.test.onegini.com/resources/")
    }

    @Test
    fun `should call request with correct HTTP client`() {
        whenever(resourceHelper.getRequest(callMock, "https://token-mobile.test.onegini.com/resources/")).thenReturn(requestMock)
        whenever(oneginiSdk.oneginiClient.userClient.implicitlyAuthenticatedUserProfile).thenReturn(UserProfile("QWERTY"))

        getImplicitResourceUseCase(callMock, resultSpy, resourceHelper)

        argumentCaptor<OkHttpClient> {
            verify(resourceHelper).callRequest(capture(), eq(requestMock), eq(resultSpy))
            Truth.assertThat(firstValue).isEqualTo(oneginiSdk.oneginiClient.userClient.implicitResourceOkHttpClient)
        }
    }
}
