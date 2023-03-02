package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.errors.wrapperError
import com.onegini.mobile.sdk.flutter.useCases.GetAccessTokenUseCase
import io.flutter.plugin.common.MethodChannel
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Answers
import org.mockito.Mock
import org.mockito.Spy
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.eq
import org.mockito.kotlin.verify
import org.mockito.kotlin.whenever

@RunWith(MockitoJUnitRunner::class)
class GetAccessTokenUseCaseTests {

    @Mock(answer = Answers.RETURNS_DEEP_STUBS)
    lateinit var oneginiSdk: OneginiSDK
    @Spy
    lateinit var resultSpy: MethodChannel.Result

    lateinit var getAccessTokenUseCase: GetAccessTokenUseCase
    @Before
    fun attach() {
        getAccessTokenUseCase = GetAccessTokenUseCase(oneginiSdk)
    }

    @Test
    fun `When the accessToken is null, Then should error with NO_USER_PROFILE_IS_AUTHENTICATED`() {
        whenever(oneginiSdk.oneginiClient.userClient.accessToken).thenReturn(null)

        getAccessTokenUseCase(resultSpy)

        verify(resultSpy).wrapperError(NO_USER_PROFILE_IS_AUTHENTICATED)
    }

    @Test
    fun `When the accessToken exists, Then should return the accessToken`() {
        whenever(oneginiSdk.oneginiClient.userClient.accessToken).thenReturn("test access token")

        getAccessTokenUseCase(resultSpy)

        verify(resultSpy).success(eq("test access token"))
    }
}