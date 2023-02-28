package com.onegini.mobile.sdk

import com.google.gson.Gson
import com.onegini.mobile.sdk.android.model.OneginiAuthenticator
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.useCases.GetNotRegisteredAuthenticatorsUseCase
import com.onegini.mobile.sdk.flutter.useCases.GetUserProfileUseCase
import io.flutter.plugin.common.MethodCall
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
class GetNotRegisteredAuthenticatorsUseCaseTests {

    @Mock(answer = Answers.RETURNS_DEEP_STUBS)
    lateinit var oneginiSdk: OneginiSDK

    @Mock
    lateinit var callMock: MethodCall

    @Mock
    lateinit var oneginiAuthenticatorFirstMock: OneginiAuthenticator

    @Mock
    lateinit var oneginiAuthenticatorSecondMock: OneginiAuthenticator

    @Spy
    lateinit var resultSpy: MethodChannel.Result

    lateinit var getNotRegisteredAuthenticatorsUseCase: GetNotRegisteredAuthenticatorsUseCase
    @Before
    fun attach() {
        val getUserProfileUseCase = GetUserProfileUseCase(oneginiSdk)
        getNotRegisteredAuthenticatorsUseCase = GetNotRegisteredAuthenticatorsUseCase(oneginiSdk, getUserProfileUseCase)
    }

    @Test
    fun `When there are no Unregistered Authenticators then an empty set should be returned`() {
        whenever(callMock.argument<String>("profileId")).thenReturn("QWERTY")
        whenever(oneginiSdk.oneginiClient.userClient.userProfiles).thenReturn(setOf(UserProfile("QWERTY")))
        whenever(oneginiSdk.oneginiClient.userClient.getNotRegisteredAuthenticators(eq(UserProfile("QWERTY")))).thenReturn(emptySet())

        getNotRegisteredAuthenticatorsUseCase(callMock, resultSpy)

        val expectedResult = Gson().toJson(emptyArray<Map<String, String>>())
        verify(resultSpy).success(expectedResult)
    }

    @Test
    fun `When the UserProfile is not found then an error should be returned`() {
        whenever(callMock.argument<String>("profileId")).thenReturn("QWERTY")

        getNotRegisteredAuthenticatorsUseCase(callMock, resultSpy)

        val message = USER_PROFILE_DOES_NOT_EXIST.message
        verify(resultSpy).error(eq(USER_PROFILE_DOES_NOT_EXIST.code.toString()), eq(message), any())
    }

    @Test
    fun `When a valid UserProfile is given and multiple not registered authenticators are found then getNotRegisteredAuthenticators should return a non-empty set`() {
        whenever(callMock.argument<String>("profileId")).thenReturn("QWERTY")
        whenever(oneginiSdk.oneginiClient.userClient.userProfiles).thenReturn(setOf(UserProfile("QWERTY")))
        whenever(oneginiSdk.oneginiClient.userClient.getNotRegisteredAuthenticators(eq(UserProfile("QWERTY")))).thenReturn(setOf(oneginiAuthenticatorFirstMock, oneginiAuthenticatorSecondMock))
        whenever(oneginiAuthenticatorFirstMock.id).thenReturn("firstId")
        whenever(oneginiAuthenticatorFirstMock.name).thenReturn("firstName")
        whenever(oneginiAuthenticatorSecondMock.id).thenReturn("secondId")
        whenever(oneginiAuthenticatorSecondMock.name).thenReturn("secondName")

        getNotRegisteredAuthenticatorsUseCase(callMock, resultSpy)

        val expectedArray = arrayOf(mapOf("id" to "firstId", "name" to "firstName"), mapOf("id" to "secondId", "name" to "secondName"))
        val expectedResult = Gson().toJson(expectedArray)
        verify(resultSpy).success(expectedResult)
    }
}
