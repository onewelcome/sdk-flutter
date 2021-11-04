package com.onegini.mobile.sdk

import com.google.gson.Gson
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.client.UserClient
import com.onegini.mobile.sdk.android.model.OneginiIdentityProvider
import com.onegini.mobile.sdk.flutter.useCases.GetIdentityProvidersUseCase
import io.flutter.plugin.common.MethodChannel
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Mock
import org.mockito.Spy
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.verify
import org.mockito.kotlin.whenever

@RunWith(MockitoJUnitRunner::class)
class GetIdentityProvidersUseCaseTests {

    @Mock
    lateinit var clientMock: OneginiClient

    @Mock
    lateinit var userClientMock: UserClient

    @Mock
    lateinit var oneginiIdentityProviderFirstMock: OneginiIdentityProvider

    @Mock
    lateinit var oneginiIdentityProviderSecondMock: OneginiIdentityProvider

    @Spy
    lateinit var resultSpy: MethodChannel.Result

    @Before
    fun attach() {
        whenever(clientMock.userClient).thenReturn(userClientMock)
    }

    @Test
    fun `should return empty list when sdk return empty set`() {
        whenever(userClientMock.identityProviders).thenReturn(emptySet())

        GetIdentityProvidersUseCase(clientMock)(resultSpy)

        val expectedResult = Gson().toJson(emptyArray<Map<String, String>>())
        verify(resultSpy).success(expectedResult)
    }

    @Test
    fun `should return list of identity providers when user have available identity providers`() {
        whenever(userClientMock.identityProviders).thenReturn(setOf(oneginiIdentityProviderFirstMock, oneginiIdentityProviderSecondMock))
        whenever(oneginiIdentityProviderFirstMock.id).thenReturn("firstId")
        whenever(oneginiIdentityProviderFirstMock.name).thenReturn("firstName")
        whenever(oneginiIdentityProviderSecondMock.id).thenReturn("secondId")
        whenever(oneginiIdentityProviderSecondMock.name).thenReturn("secondName")

        GetIdentityProvidersUseCase(clientMock)(resultSpy)

        val expectedArray = arrayOf(mapOf("id" to "firstId", "name" to "firstName"), mapOf("id" to "secondId", "name" to "secondName"))
        val expectedResult = Gson().toJson(expectedArray)
        verify(resultSpy).success(expectedResult)
    }
}