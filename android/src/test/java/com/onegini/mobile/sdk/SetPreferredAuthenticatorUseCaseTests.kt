package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.model.OneginiAuthenticator
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.useCases.SetPreferredAuthenticatorUseCase
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
class SetPreferredAuthenticatorUseCaseTests {

    @Mock(answer = Answers.RETURNS_DEEP_STUBS)
    lateinit var oneginiSdk: OneginiSDK

    @Mock
    lateinit var clientMock: OneginiClient
    @Mock
    lateinit var callMock: MethodCall

    @Mock
    lateinit var oneginiAuthenticatorMock: OneginiAuthenticator

    @Spy
    lateinit var resultSpy: MethodChannel.Result

    lateinit var setPreferredAuthenticatorUseCase: SetPreferredAuthenticatorUseCase

    @Before
    fun attach() {
        setPreferredAuthenticatorUseCase = SetPreferredAuthenticatorUseCase(oneginiSdk)
    }

    @Test
    fun `should return error when UserProfiles method return empty set `() {
        whenever(oneginiSdk.oneginiClient.userClient.userProfiles).thenReturn(emptySet())

        setPreferredAuthenticatorUseCase(callMock, resultSpy)

        val message = USER_PROFILE_DOES_NOT_EXIST.message
        verify(resultSpy).error(eq(USER_PROFILE_DOES_NOT_EXIST.code.toString()), eq(message), any())
    }

    @Test
    fun `should return error with authenticator id as a param when given authenticator id is null`() {
        whenever(oneginiSdk.oneginiClient.userClient.userProfiles).thenReturn(setOf(UserProfile("QWERTY")))
        whenever(oneginiSdk.oneginiClient.userClient.getRegisteredAuthenticators(eq(UserProfile("QWERTY")))).thenReturn(setOf(oneginiAuthenticatorMock))
        whenever(oneginiAuthenticatorMock.id).thenReturn("test")

        setPreferredAuthenticatorUseCase(callMock, resultSpy)

        val message = AUTHENTICATOR_NOT_FOUND.message
        verify(resultSpy).error(eq(AUTHENTICATOR_NOT_FOUND.code.toString()), eq(message), any())
    }

    @Test
    fun `should return error with authenticator id as a param when getRegisteredAuthenticators method return empty set`() {
        whenever(callMock.argument<String>("authenticatorId")).thenReturn("test")
        whenever(oneginiSdk.oneginiClient.userClient.userProfiles).thenReturn(setOf(UserProfile("QWERTY")))
        whenever(oneginiSdk.oneginiClient.userClient.getRegisteredAuthenticators(eq(UserProfile("QWERTY")))).thenReturn(emptySet())

        setPreferredAuthenticatorUseCase(callMock, resultSpy)

        val message = AUTHENTICATOR_NOT_FOUND.message
        verify(resultSpy).error(eq(AUTHENTICATOR_NOT_FOUND.code.toString()), eq(message), any())
    }

    @Test
    fun `should return success with authenticator id as a param when given authenticator id found in getRegisteredAuthenticators method`() {
        whenever(callMock.argument<String>("authenticatorId")).thenReturn("test")
        whenever(oneginiSdk.oneginiClient.userClient.userProfiles).thenReturn(setOf(UserProfile("QWERTY")))
        whenever(oneginiSdk.oneginiClient.userClient.getRegisteredAuthenticators(eq(UserProfile("QWERTY")))).thenReturn(setOf(oneginiAuthenticatorMock))
        whenever(oneginiAuthenticatorMock.id).thenReturn("test")

        setPreferredAuthenticatorUseCase(callMock, resultSpy)

        verify(resultSpy).success(eq(true))
    }
}
