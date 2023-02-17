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
import org.mockito.Mockito
import org.mockito.Spy
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.eq
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
    fun `should return empty string when redirectUrl is empty string in SDK`() {
        whenever(oneginiClientConfigModelMock.redirectUri).thenReturn("")

        getRedirectUrlUseCase(resultSpy)

        verify(resultSpy).success("")
    }

    @Test
    fun `should return string when redirectUrl exist in SDK`() {
        whenever(oneginiClientConfigModelMock.redirectUri).thenReturn("http://test.com")

        getRedirectUrlUseCase(resultSpy)

        verify(resultSpy).success("http://test.com")
    }
}