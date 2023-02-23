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
    fun `When no user is authenticated then return an error`() {
        whenever(callMock.argument<String>("authenticatorId")).thenReturn("test")
        whenever(oneginiSdk.oneginiClient.userClient.authenticatedUserProfile).thenReturn(null)

        setPreferredAuthenticatorUseCase(callMock, resultSpy)

        val message = NO_USER_PROFILE_IS_AUTHENTICATED.message
        verify(resultSpy).error(eq(NO_USER_PROFILE_IS_AUTHENTICATED.code.toString()), eq(message), any())
    }

    @Test
    fun `When an authenticator id is null then an error should be thrown`() {
        whenever(oneginiSdk.oneginiClient.userClient.authenticatedUserProfile).thenReturn(UserProfile("QWERTY"))
        whenever(oneginiSdk.oneginiClient.userClient.getRegisteredAuthenticators(eq(UserProfile("QWERTY")))).thenReturn(setOf(oneginiAuthenticatorMock))
        whenever(oneginiAuthenticatorMock.id).thenReturn("test")

        setPreferredAuthenticatorUseCase(callMock, resultSpy)

        val message = METHOD_ARGUMENT_NOT_FOUND.message
        verify(resultSpy).error(eq(METHOD_ARGUMENT_NOT_FOUND.code.toString()), eq(message), any())
    }

    @Test
    fun `When an authenticator id is given that is not related to the authenticated user then an error should be thrown`() {
        whenever(callMock.argument<String>("authenticatorId")).thenReturn("test")
        whenever(oneginiSdk.oneginiClient.userClient.authenticatedUserProfile).thenReturn(UserProfile("QWERTY"))
        whenever(oneginiSdk.oneginiClient.userClient.getRegisteredAuthenticators(eq(UserProfile("QWERTY")))).thenReturn(emptySet())

        setPreferredAuthenticatorUseCase(callMock, resultSpy)

        val message = AUTHENTICATOR_NOT_FOUND.message
        verify(resultSpy).error(eq(AUTHENTICATOR_NOT_FOUND.code.toString()), eq(message), any())
    }

    @Test
    fun `should return success with authenticator id as a param when given authenticator id found in getRegisteredAuthenticators method`() {
        whenever(callMock.argument<String>("authenticatorId")).thenReturn("test")
        whenever(oneginiSdk.oneginiClient.userClient.authenticatedUserProfile).thenReturn(UserProfile("QWERTY"))
        whenever(oneginiSdk.oneginiClient.userClient.getRegisteredAuthenticators(eq(UserProfile("QWERTY")))).thenReturn(setOf(oneginiAuthenticatorMock))
        whenever(oneginiAuthenticatorMock.id).thenReturn("test")

        setPreferredAuthenticatorUseCase(callMock, resultSpy)

        verify(resultSpy).success(eq(true))
    }
}
