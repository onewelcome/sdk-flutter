package com.onegini.mobile.sdk


import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.client.UserClient
import com.onegini.mobile.sdk.android.model.OneginiAuthenticator
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.useCases.SetPreferredAuthenticatorUseCase
import io.flutter.plugin.common.MethodCall
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
class SetPreferredAuthenticatorUseCaseTests {

    @Mock
    lateinit var clientMock: OneginiClient

    @Mock
    lateinit var userClientMock: UserClient

    @Mock
    lateinit var callMock: MethodCall

    @Mock
    lateinit var oneginiAuthenticatorMock: OneginiAuthenticator

    @Spy
    lateinit var resultSpy: MethodChannel.Result

    @Before
    fun attach() {
        whenever(clientMock.userClient).thenReturn(userClientMock)
    }

    @Test
    fun `should return error when UserProfiles method return empty set `() {
        whenever(userClientMock.userProfiles).thenReturn(emptySet())

        SetPreferredAuthenticatorUseCase(clientMock)(callMock, resultSpy)

        verify(resultSpy).error(USER_PROFILE_IS_NULL_ERROR.code.toString(), USER_PROFILE_IS_NULL_ERROR.message, null)
    }

    @Test
    fun `should return error with authenticator id as a param when given authenticator id is null`() {
        whenever(userClientMock.userProfiles).thenReturn(setOf(UserProfile("QWERTY")))
        whenever(userClientMock.getRegisteredAuthenticators(eq(UserProfile("QWERTY")))).thenReturn(setOf(oneginiAuthenticatorMock))
        whenever(oneginiAuthenticatorMock.id).thenReturn("test")

        SetPreferredAuthenticatorUseCase(clientMock)(callMock, resultSpy)

        verify(resultSpy).error(AUTHENTICATOR_IS_NULL_ERROR.code.toString(), AUTHENTICATOR_IS_NULL_ERROR.message, null)
    }

    @Test
    fun `should return error with authenticator id as a param when getRegisteredAuthenticators method return empty set`() {
        whenever(callMock.argument<String>("authenticatorId")).thenReturn("test")
        whenever(userClientMock.userProfiles).thenReturn(setOf(UserProfile("QWERTY")))
        whenever(userClientMock.getRegisteredAuthenticators(eq(UserProfile("QWERTY")))).thenReturn(emptySet())

        SetPreferredAuthenticatorUseCase(clientMock)(callMock, resultSpy)

        verify(resultSpy).error(AUTHENTICATOR_IS_NULL_ERROR.code.toString(), AUTHENTICATOR_IS_NULL_ERROR.message, null)
    }

    @Test
    fun `should return success with authenticator id as a param when given authenticator id found in getRegisteredAuthenticators method`() {
        whenever(callMock.argument<String>("authenticatorId")).thenReturn("test")
        whenever(userClientMock.userProfiles).thenReturn(setOf(UserProfile("QWERTY")))
        whenever(userClientMock.getRegisteredAuthenticators(eq(UserProfile("QWERTY")))).thenReturn(setOf(oneginiAuthenticatorMock))
        whenever(oneginiAuthenticatorMock.id).thenReturn("test")

        SetPreferredAuthenticatorUseCase(clientMock)(callMock, resultSpy)

        verify(resultSpy).success(eq(true))
    }
}
