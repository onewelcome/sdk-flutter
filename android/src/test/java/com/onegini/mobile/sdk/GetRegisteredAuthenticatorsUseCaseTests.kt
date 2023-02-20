package com.onegini.mobile.sdk

import com.google.gson.Gson
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.client.UserClient
import com.onegini.mobile.sdk.android.model.OneginiAuthenticator
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.useCases.GetRegisteredAuthenticatorsUseCase
import io.flutter.plugin.common.MethodChannel
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Answers
import org.mockito.Mock
import org.mockito.Spy
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.any
import org.mockito.kotlin.eq
import org.mockito.kotlin.verify
import org.mockito.kotlin.whenever

@RunWith(MockitoJUnitRunner::class)
class GetRegisteredAuthenticatorsUseCaseTests {

    @Mock(answer = Answers.RETURNS_DEEP_STUBS)
    lateinit var oneginiSdk: OneginiSDK

    @Mock
    lateinit var clientMock: OneginiClient
    @Mock
    lateinit var oneginiAuthenticatorFirstMock: OneginiAuthenticator

    @Mock
    lateinit var oneginiAuthenticatorSecondMock: OneginiAuthenticator

    @Spy
    lateinit var resultSpy: MethodChannel.Result

    lateinit var getRegisteredAuthenticatorsUseCase: GetRegisteredAuthenticatorsUseCase
    @Before
    fun attach() {
        getRegisteredAuthenticatorsUseCase = GetRegisteredAuthenticatorsUseCase(oneginiSdk)
    }

    @Test
    fun `should return empty list when sdk return empty set`() {
        whenever(oneginiSdk.oneginiClient.userClient.userProfiles).thenReturn(setOf(UserProfile("QWERTY")))
        whenever(oneginiSdk.oneginiClient.userClient.getRegisteredAuthenticators(eq(UserProfile("QWERTY")))).thenReturn(emptySet())

        getRegisteredAuthenticatorsUseCase(resultSpy)

        val expectedResult = Gson().toJson(emptyArray<Map<String, String>>())
        verify(resultSpy).success(expectedResult)
    }

    @Test
    fun `should return error when UserProfile is null`() {
        whenever(oneginiSdk.oneginiClient.userClient.userProfiles).thenReturn(emptySet())

        getRegisteredAuthenticatorsUseCase(resultSpy)

        val message = USER_PROFILE_DOES_NOT_EXIST.message
        verify(resultSpy).error(eq(USER_PROFILE_DOES_NOT_EXIST.code.toString()), eq(message), any())
    }

    @Test
    fun `should return list of registered authenticators when getRegisteredAuthenticators method returns not empty set`() {
        whenever(oneginiSdk.oneginiClient.userClient.userProfiles).thenReturn(setOf(UserProfile("QWERTY")))
        whenever(oneginiSdk.oneginiClient.userClient.getRegisteredAuthenticators(eq(UserProfile("QWERTY")))).thenReturn(setOf(oneginiAuthenticatorFirstMock, oneginiAuthenticatorSecondMock))
        whenever(oneginiAuthenticatorFirstMock.id).thenReturn("firstId")
        whenever(oneginiAuthenticatorFirstMock.name).thenReturn("firstName")
        whenever(oneginiAuthenticatorSecondMock.id).thenReturn("secondId")
        whenever(oneginiAuthenticatorSecondMock.name).thenReturn("secondName")

        getRegisteredAuthenticatorsUseCase(resultSpy)

        val expectedArray = arrayOf(mapOf("id" to "firstId", "name" to "firstName"), mapOf("id" to "secondId", "name" to "secondName"))
        val expectedResult = Gson().toJson(expectedArray)
        verify(resultSpy).success(expectedResult)
    }
}