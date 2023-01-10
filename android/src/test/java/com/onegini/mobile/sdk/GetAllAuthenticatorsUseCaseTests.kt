package com.onegini.mobile.sdk

import com.google.gson.Gson
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.client.UserClient
import com.onegini.mobile.sdk.android.model.OneginiAuthenticator
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors
import com.onegini.mobile.sdk.flutter.useCases.GetAllAuthenticatorsUseCase
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
class GetAllAuthenticatorsUseCaseTests {
    @Mock
    lateinit var clientMock: OneginiClient

    @Mock
    lateinit var userClientMock: UserClient

    @Mock
    lateinit var oneginiAuthenticatorMock: OneginiAuthenticator

    @Mock
    lateinit var userProfileMock: UserProfile

    @Spy
    lateinit var resultSpy: MethodChannel.Result

    @Before
    fun attach() {
        whenever(clientMock.userClient).thenReturn(userClientMock)
    }

    @Test
    fun `should return error when user is not authenticated`() {
        whenever(userClientMock.authenticatedUserProfile).thenReturn(null)

        GetAllAuthenticatorsUseCase(clientMock)(resultSpy)

        verify(resultSpy).error(OneWelcomeWrapperErrors.AUTHENTICATED_USER_PROFILE_IS_NULL.code, OneWelcomeWrapperErrors.AUTHENTICATED_USER_PROFILE_IS_NULL.message, null)
    }

    @Test
    fun `should return empty when getAllAuthenticators method return empty set`() {
        whenever(userClientMock.authenticatedUserProfile).thenReturn(userProfileMock)
        whenever(userClientMock.getAllAuthenticators(userProfileMock)).thenReturn(emptySet())

        GetAllAuthenticatorsUseCase(clientMock)(resultSpy)

        val expectedResult = Gson().toJson(emptyArray<Map<String, String>>())
        verify(resultSpy).success(expectedResult)
    }

    @Test
    fun `should return array of map when getAllAuthenticators method return set of authenticators`() {
        whenever(userClientMock.authenticatedUserProfile).thenReturn(userProfileMock)
        whenever(userClientMock.getAllAuthenticators(userProfileMock)).thenReturn(setOf(oneginiAuthenticatorMock))
        whenever(oneginiAuthenticatorMock.name).thenReturn("test")
        whenever(oneginiAuthenticatorMock.id).thenReturn("test")

        GetAllAuthenticatorsUseCase(clientMock)(resultSpy)

        val expectedResult = Gson().toJson(arrayOf(mapOf("id" to "test", "name" to "test")))
        verify(resultSpy).success(expectedResult)
    }


}