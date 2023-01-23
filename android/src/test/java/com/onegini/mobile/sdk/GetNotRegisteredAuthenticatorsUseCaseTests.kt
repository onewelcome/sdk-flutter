package com.onegini.mobile.sdk

import com.google.gson.Gson
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.client.UserClient
import com.onegini.mobile.sdk.android.model.OneginiAuthenticator
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.useCases.GetNotRegisteredAuthenticatorsUseCase
import io.flutter.plugin.common.MethodChannel
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Mock
import org.mockito.Spy
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.eq
import org.mockito.kotlin.verify
import org.mockito.kotlin.whenever


@RunWith(MockitoJUnitRunner::class)
class GetNotRegisteredAuthenticatorsUseCaseTests {
    @Mock
    lateinit var clientMock: OneginiClient

    @Mock
    lateinit var userClientMock: UserClient

    @Mock
    lateinit var oneginiAuthenticatorFirstMock: OneginiAuthenticator

    @Mock
    lateinit var oneginiAuthenticatorSecondMock: OneginiAuthenticator

    @Spy
    lateinit var resultSpy: MethodChannel.Result

    @Before
    fun attach() {
        whenever(clientMock.userClient).thenReturn(userClientMock)
    }

    @Test
    fun `should return empty list when sdk return empty set`() {
        whenever(userClientMock.authenticatedUserProfile).thenReturn(UserProfile("QWERTY"))
        whenever(userClientMock.getNotRegisteredAuthenticators(eq(UserProfile("QWERTY")))).thenReturn(emptySet())

        GetNotRegisteredAuthenticatorsUseCase(clientMock)(resultSpy)

        val expectedResult = Gson().toJson(emptyArray<Map<String, String>>())
        verify(resultSpy).success(expectedResult)
    }

    @Test
    fun `should return error when authenticatedUserProfile is null`() {
        whenever(userClientMock.authenticatedUserProfile).thenReturn(null)

        GetNotRegisteredAuthenticatorsUseCase(clientMock)(resultSpy)

        verify(resultSpy).error(AUTHENTICATED_USER_PROFILE_IS_NULL_ERROR.code.toString(), AUTHENTICATED_USER_PROFILE_IS_NULL_ERROR.message, null)
    }

    @Test
    fun `should return list of  not registered authenticators when getNotRegisteredAuthenticators method returns not empty set`() {
        whenever(userClientMock.authenticatedUserProfile).thenReturn(UserProfile("QWERTY"))
        whenever(userClientMock.getNotRegisteredAuthenticators(eq(UserProfile("QWERTY")))).thenReturn(setOf(oneginiAuthenticatorFirstMock, oneginiAuthenticatorSecondMock))
        whenever(oneginiAuthenticatorFirstMock.id).thenReturn("firstId")
        whenever(oneginiAuthenticatorFirstMock.name).thenReturn("firstName")
        whenever(oneginiAuthenticatorSecondMock.id).thenReturn("secondId")
        whenever(oneginiAuthenticatorSecondMock.name).thenReturn("secondName")

        GetNotRegisteredAuthenticatorsUseCase(clientMock)(resultSpy)

        val expectedArray = arrayOf(mapOf("id" to "firstId", "name" to "firstName"), mapOf("id" to "secondId", "name" to "secondName"))
        val expectedResult = Gson().toJson(expectedArray)
        verify(resultSpy).success(expectedResult)
    }

}