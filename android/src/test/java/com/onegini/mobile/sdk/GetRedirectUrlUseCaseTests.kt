package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.model.OneginiClientConfigModel
import com.onegini.mobile.sdk.flutter.useCases.GetRedirectUrlUseCase
import io.flutter.plugin.common.MethodChannel
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Mock
import org.mockito.Mockito
import org.mockito.Spy
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.eq
import org.mockito.kotlin.whenever

@RunWith(MockitoJUnitRunner::class)
class GetRedirectUrlUseCaseTests {

    @Mock
    lateinit var clientMock: OneginiClient

    @Mock
    lateinit var oneginiClientConfigModelMock: OneginiClientConfigModel

    @Spy
    lateinit var resultSpy: MethodChannel.Result

    @Before
    fun attach() {
        whenever(clientMock.configModel).thenReturn(oneginiClientConfigModelMock)
    }

    @Test
    fun `should return empty string when redirectUrl is empty string in SDK`() {
        whenever(oneginiClientConfigModelMock.redirectUri).thenReturn("")

        GetRedirectUrlUseCase(clientMock)(resultSpy)

        Mockito.verify(resultSpy).success("")
    }

    @Test
    fun `should return string when redirectUrl exist in SDK`() {
        whenever(oneginiClientConfigModelMock.redirectUri).thenReturn("http://test.com")

        GetRedirectUrlUseCase(clientMock)(resultSpy)

        Mockito.verify(resultSpy).success("http://test.com")
    }
}