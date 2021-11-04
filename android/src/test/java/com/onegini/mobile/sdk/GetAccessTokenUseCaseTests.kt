package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.client.UserClient
import com.onegini.mobile.sdk.flutter.useCases.GetAccessTokenUseCase
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
class GetAccessTokenUseCaseTests {

    @Mock
    lateinit var clientMock: OneginiClient

    @Mock
    lateinit var userClientMock: UserClient

    @Spy
    lateinit var resultSpy: MethodChannel.Result

    @Before
    fun attach() {
        whenever(clientMock.userClient).thenReturn(userClientMock)
    }

    @Test
    fun `should return null when access token is null in SDK`() {
        whenever(userClientMock.accessToken).thenReturn(null)

        GetAccessTokenUseCase(clientMock)(resultSpy)

        Mockito.verify(resultSpy).success(null)
    }

    @Test
    fun `should return access token when access token exist in SDK`() {
        whenever(userClientMock.accessToken).thenReturn("test access token")

        GetAccessTokenUseCase(clientMock)(resultSpy)

        Mockito.verify(resultSpy).success(eq("test access token"))
    }
}