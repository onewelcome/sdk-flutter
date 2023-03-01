package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.model.OneginiClientConfigModel
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.useCases.GetRedirectUrlUseCase
import io.flutter.plugin.common.MethodChannel
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Answers
import org.mockito.Mock
import org.mockito.Spy
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.verify
import org.mockito.kotlin.whenever

@RunWith(MockitoJUnitRunner::class)
class GetRedirectUrlUseCaseTests {

    @Mock(answer = Answers.RETURNS_DEEP_STUBS)
    lateinit var oneginiSdk: OneginiSDK

    @Mock
    lateinit var clientMock: OneginiClient

    @Mock
    lateinit var oneginiClientConfigModelMock: OneginiClientConfigModel

    @Spy
    lateinit var resultSpy: MethodChannel.Result

    lateinit var getRedirectUrlUseCase: GetRedirectUrlUseCase
    @Before
    fun attach() {
        getRedirectUrlUseCase = GetRedirectUrlUseCase(oneginiSdk)
        whenever(oneginiSdk.oneginiClient.configModel).thenReturn(oneginiClientConfigModelMock)
    }

    @Test
    fun `When redirectUri is an empty string, Then call success with empty string`() {
        whenever(oneginiClientConfigModelMock.redirectUri).thenReturn("")

        getRedirectUrlUseCase(resultSpy)

        verify(resultSpy).success("")
    }

    @Test
    fun `When redirectUri is a non-empty string, Then call sucess with that string`() {
        whenever(oneginiClientConfigModelMock.redirectUri).thenReturn("http://test.com")

        getRedirectUrlUseCase(resultSpy)

        verify(resultSpy).success("http://test.com")
    }
}