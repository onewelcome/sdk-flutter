package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.android.handlers.OneginiAuthenticatorDeregistrationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiAuthenticatorDeregistrationError
import com.onegini.mobile.sdk.android.model.OneginiAuthenticator
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.useCases.DeregisterAuthenticatorUseCase
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
class DeregisterAuthenticatorUseCaseTests {

    @Mock(answer = Answers.RETURNS_DEEP_STUBS)
    lateinit var oneginiSdk: OneginiSDK

    @Mock
    lateinit var callMock: MethodCall

    @Mock
    lateinit var oneginiAuthenticatorMock: OneginiAuthenticator

    @Mock
    lateinit var oneginiAuthenticatorDeregistrationErrorMock: OneginiAuthenticatorDeregistrationError

    @Spy
    lateinit var resultSpy: MethodChannel.Result

    lateinit var deregisterAuthenticatorUseCase: DeregisterAuthenticatorUseCase
    @Before
    fun attach() {
        deregisterAuthenticatorUseCase = DeregisterAuthenticatorUseCase(oneginiSdk)
    }

    @Test
    fun `When no user is authenticated, Then it should return error`() {
        whenever(callMock.argument<String>("authenticatorId")).thenReturn("test")
        whenever(oneginiSdk.oneginiClient.userClient.authenticatedUserProfile).thenReturn(null)

        deregisterAuthenticatorUseCase(callMock, resultSpy)

        val message = NO_USER_PROFILE_IS_AUTHENTICATED.message
        verify(resultSpy).error(eq(NO_USER_PROFILE_IS_AUTHENTICATED.code.toString()), eq(message), any())
    }

    @Test
    fun `When the given authenticator id is not found within the registered authenticators of the authenticated user, Then it should return an error`() {
        whenever(callMock.argument<String>("authenticatorId")).thenReturn("test")
        whenever(oneginiSdk.oneginiClient.userClient.authenticatedUserProfile).thenReturn(UserProfile("QWERTY"))
        whenever(oneginiSdk.oneginiClient.userClient.getRegisteredAuthenticators(eq(UserProfile("QWERTY")))).thenReturn(setOf(oneginiAuthenticatorMock))
        whenever(oneginiAuthenticatorMock.id).thenReturn("other_test")

        deregisterAuthenticatorUseCase(callMock, resultSpy)

        val message = AUTHENTICATOR_NOT_FOUND.message
        verify(resultSpy).error(eq(AUTHENTICATOR_NOT_FOUND.code.toString()), eq(message), any())
    }

    @Test
    fun `When getRegisteredAuthenticators method returns empty set, Then an error should be returned`() {
        whenever(callMock.argument<String>("authenticatorId")).thenReturn("test")
        whenever(oneginiSdk.oneginiClient.userClient.authenticatedUserProfile).thenReturn(UserProfile("QWERTY"))
        whenever(oneginiSdk.oneginiClient.userClient.getRegisteredAuthenticators(eq(UserProfile("QWERTY")))).thenReturn(emptySet())

        deregisterAuthenticatorUseCase(callMock, resultSpy)

        val message = AUTHENTICATOR_NOT_FOUND.message
        verify(resultSpy).error(eq(AUTHENTICATOR_NOT_FOUND.code.toString()), eq(message), any())
    }

    @Test
    fun `When getRegisteredAuthenticators finds an authenticator for a authenticated user, Then it should return true`() {
        whenever(callMock.argument<String>("authenticatorId")).thenReturn("test")
        whenever(oneginiSdk.oneginiClient.userClient.authenticatedUserProfile).thenReturn(UserProfile("QWERTY"))
        whenever(oneginiSdk.oneginiClient.userClient.getRegisteredAuthenticators(eq(UserProfile("QWERTY")))).thenReturn(setOf(oneginiAuthenticatorMock))
        whenever(oneginiAuthenticatorMock.id).thenReturn("test")
        whenever(oneginiSdk.oneginiClient.userClient.deregisterAuthenticator(eq(oneginiAuthenticatorMock), any())).thenAnswer {
            it.getArgument<OneginiAuthenticatorDeregistrationHandler>(1).onSuccess()
        }

        deregisterAuthenticatorUseCase(callMock, resultSpy)

        verify(resultSpy).success(eq(true))
    }

    @Test
    fun `When deregisterAuthenticator method returns error, Then the function should return an error`() {
        whenever(callMock.argument<String>("authenticatorId")).thenReturn("test")
        whenever(oneginiSdk.oneginiClient.userClient.authenticatedUserProfile).thenReturn(UserProfile("QWERTY"))
        whenever(oneginiSdk.oneginiClient.userClient.getRegisteredAuthenticators(eq(UserProfile("QWERTY")))).thenReturn(setOf(oneginiAuthenticatorMock))
        whenever(oneginiAuthenticatorMock.id).thenReturn("test")
        whenever(oneginiAuthenticatorDeregistrationErrorMock.errorType).thenReturn(OneginiAuthenticatorDeregistrationError.GENERAL_ERROR)
        whenever(oneginiAuthenticatorDeregistrationErrorMock.message).thenReturn("General error")
        whenever(oneginiSdk.oneginiClient.userClient.deregisterAuthenticator(eq(oneginiAuthenticatorMock), any())).thenAnswer {
            it.getArgument<OneginiAuthenticatorDeregistrationHandler>(1).onError(oneginiAuthenticatorDeregistrationErrorMock)
        }

        deregisterAuthenticatorUseCase(callMock, resultSpy)

        val message = oneginiAuthenticatorDeregistrationErrorMock.message
        verify(resultSpy).error(eq(oneginiAuthenticatorDeregistrationErrorMock.errorType.toString()), eq(message), any()) 
    }}