package com.onegini.mobile.sdk

import com.google.gson.Gson
import com.onegini.mobile.sdk.android.model.OneginiAuthenticator
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.useCases.GetAllAuthenticatorsUseCase
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
class GetAllAuthenticatorsUseCaseTests {
    @Mock(answer = Answers.RETURNS_DEEP_STUBS)
    lateinit var oneginiSdk: OneginiSDK

    @Mock
    lateinit var oneginiAuthenticatorMock: OneginiAuthenticator

    @Mock
    lateinit var userProfileMock: UserProfile

    @Spy
    lateinit var resultSpy: MethodChannel.Result

    lateinit var getAllAuthenticatorsUseCase: GetAllAuthenticatorsUseCase
    @Before
    fun attach() {
        getAllAuthenticatorsUseCase = GetAllAuthenticatorsUseCase(oneginiSdk)
    }

    @Test
    fun `should return error when user is not authenticated`() {
        whenever(oneginiSdk.oneginiClient.userClient.authenticatedUserProfile).thenReturn(null)

        getAllAuthenticatorsUseCase(resultSpy)

        val message = AUTHENTICATED_USER_PROFILE_IS_NULL.message
        verify(resultSpy).error(eq(AUTHENTICATED_USER_PROFILE_IS_NULL.code.toString()), eq(message), any())
    }

    @Test
    fun `should return empty when getAllAuthenticators method return empty set`() {
        whenever(oneginiSdk.oneginiClient.userClient.authenticatedUserProfile).thenReturn(userProfileMock)
        whenever(oneginiSdk.oneginiClient.userClient.getAllAuthenticators(userProfileMock)).thenReturn(emptySet())

        getAllAuthenticatorsUseCase(resultSpy)

        val expectedResult = Gson().toJson(emptyArray<Map<String, String>>())
        verify(resultSpy).success(expectedResult)
    }

    @Test
    fun `should return array of map when getAllAuthenticators method return set of authenticators`() {
        whenever(oneginiSdk.oneginiClient.userClient.authenticatedUserProfile).thenReturn(userProfileMock)
        whenever(oneginiSdk.oneginiClient.userClient.getAllAuthenticators(userProfileMock)).thenReturn(setOf(oneginiAuthenticatorMock))
        whenever(oneginiAuthenticatorMock.name).thenReturn("test")
        whenever(oneginiAuthenticatorMock.id).thenReturn("test")

        getAllAuthenticatorsUseCase(resultSpy)

        val expectedResult = Gson().toJson(arrayOf(mapOf("id" to "test", "name" to "test")))
        verify(resultSpy).success(expectedResult)
    }}