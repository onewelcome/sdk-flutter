package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.client.UserClient
import com.onegini.mobile.sdk.android.handlers.OneginiAuthenticatorDeregistrationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiAuthenticatorDeregistrationError
import com.onegini.mobile.sdk.android.model.OneginiAuthenticator
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneginiWrapperErrors
import com.onegini.mobile.sdk.flutter.useCases.DeregisterAuthenticatorUseCase
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Mock
import org.mockito.Spy
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.any
import org.mockito.kotlin.eq
import org.mockito.kotlin.verify
import org.mockito.kotlin.whenever


@RunWith(MockitoJUnitRunner::class)
class DeregisterAuthenticatorUseCaseTests {

    @Mock
    lateinit var clientMock: OneginiClient

    @Mock
    lateinit var userClientMock: UserClient

    @Mock
    lateinit var callMock: MethodCall

    @Mock
    lateinit var oneginiAuthenticatorMock: OneginiAuthenticator

    @Mock
    lateinit var oneginiAuthenticatorDeregistrationErrorMock: OneginiAuthenticatorDeregistrationError

    @Spy
    lateinit var resultSpy: MethodChannel.Result

    @Before
    fun attach() {
        whenever(clientMock.userClient).thenReturn(userClientMock)
    }

    @Test
    fun `should return error when UserProfiles method returns empty set `() {
        whenever(userClientMock.userProfiles).thenReturn(emptySet())

        DeregisterAuthenticatorUseCase(clientMock)(callMock, resultSpy)

        verify(resultSpy).error(OneginiWrapperErrors.USER_PROFILE_IS_NULL.code, OneginiWrapperErrors.USER_PROFILE_IS_NULL.message, null)
    }

    @Test
    fun `should return error when given authenticator id is null`() {
        whenever(userClientMock.userProfiles).thenReturn(setOf(UserProfile("QWERTY")))
        whenever(userClientMock.getRegisteredAuthenticators(eq(UserProfile("QWERTY")))).thenReturn(setOf(oneginiAuthenticatorMock))
        whenever(oneginiAuthenticatorMock.id).thenReturn("test")

        DeregisterAuthenticatorUseCase(clientMock)(callMock, resultSpy)

        verify(resultSpy).error(OneginiWrapperErrors.AUTHENTICATOR_IS_NULL.code, OneginiWrapperErrors.AUTHENTICATOR_IS_NULL.message, null)
    }

    @Test
    fun `should return error when getRegisteredAuthenticators method returns empty set`() {
        whenever(callMock.argument<String>("authenticatorId")).thenReturn("test")
        whenever(userClientMock.userProfiles).thenReturn(setOf(UserProfile("QWERTY")))
        whenever(userClientMock.getRegisteredAuthenticators(eq(UserProfile("QWERTY")))).thenReturn(emptySet())

        DeregisterAuthenticatorUseCase(clientMock)(callMock, resultSpy)

        verify(resultSpy).error(OneginiWrapperErrors.AUTHENTICATOR_IS_NULL.code, OneginiWrapperErrors.AUTHENTICATOR_IS_NULL.message, null)
    }

    @Test
    fun `should return true when given authenticator id found in getRegisteredAuthenticators method`() {
        whenever(callMock.argument<String>("authenticatorId")).thenReturn("test")
        whenever(userClientMock.userProfiles).thenReturn(setOf(UserProfile("QWERTY")))
        whenever(userClientMock.getRegisteredAuthenticators(eq(UserProfile("QWERTY")))).thenReturn(setOf(oneginiAuthenticatorMock))
        whenever(oneginiAuthenticatorMock.id).thenReturn("test")
        whenever(userClientMock.deregisterAuthenticator(eq(oneginiAuthenticatorMock), any())).thenAnswer {
            it.getArgument<OneginiAuthenticatorDeregistrationHandler>(1).onSuccess()
        }

        DeregisterAuthenticatorUseCase(clientMock)(callMock, resultSpy)

        verify(resultSpy).success(eq(true))
    }

    @Test
    fun `should return error when deregisterAuthenticator method returns error`() {
        whenever(callMock.argument<String>("authenticatorId")).thenReturn("test")
        whenever(userClientMock.userProfiles).thenReturn(setOf(UserProfile("QWERTY")))
        whenever(userClientMock.getRegisteredAuthenticators(eq(UserProfile("QWERTY")))).thenReturn(setOf(oneginiAuthenticatorMock))
        whenever(oneginiAuthenticatorMock.id).thenReturn("test")
        whenever(oneginiAuthenticatorDeregistrationErrorMock.errorType).thenReturn(OneginiAuthenticatorDeregistrationError.GENERAL_ERROR)
        whenever(oneginiAuthenticatorDeregistrationErrorMock.message).thenReturn("General error")
        whenever(userClientMock.deregisterAuthenticator(eq(oneginiAuthenticatorMock), any())).thenAnswer {
            it.getArgument<OneginiAuthenticatorDeregistrationHandler>(1).onError(oneginiAuthenticatorDeregistrationErrorMock)
        }

        DeregisterAuthenticatorUseCase(clientMock)(callMock, resultSpy)

        verify(resultSpy).error(oneginiAuthenticatorDeregistrationErrorMock.errorType.toString(), oneginiAuthenticatorDeregistrationErrorMock.message, null)
    }


}