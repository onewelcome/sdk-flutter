package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.client.UserClient
import com.onegini.mobile.sdk.android.model.OneginiAuthenticator
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors
import com.onegini.mobile.sdk.flutter.useCases.IsAuthenticatorRegisteredUseCase
import io.flutter.plugin.common.MethodCall
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
class IsAuthenticatorRegisteredUseCaseTests {

    @Mock
    lateinit var clientMock: OneginiClient

    @Mock
    lateinit var userClientMock: UserClient

    @Mock
    lateinit var callMock: MethodCall

    @Mock
    lateinit var userProfile: UserProfile

    @Mock
    lateinit var oneginiAuthenticator: OneginiAuthenticator

    @Spy
    lateinit var resultSpy: MethodChannel.Result

    @Before
    fun attach() {
        whenever(clientMock.userClient).thenReturn(userClientMock)
    }

    @Test
    fun `should return error when user is not authenticated`() {
        whenever(userClientMock.authenticatedUserProfile).thenReturn(null)

        IsAuthenticatorRegisteredUseCase(clientMock)(callMock,resultSpy)

        verify(resultSpy).error(OneWelcomeWrapperErrors.AUTHENTICATED_USER_PROFILE_IS_NULL.code, OneWelcomeWrapperErrors.AUTHENTICATED_USER_PROFILE_IS_NULL.message, null)
    }

    @Test
    fun `should return error when authenticator id is null`() {
        whenever(userClientMock.authenticatedUserProfile).thenReturn(userProfile)

        IsAuthenticatorRegisteredUseCase(clientMock)(callMock,resultSpy)

        verify(resultSpy).error(OneWelcomeWrapperErrors.AUTHENTICATOR_NOT_FOUND.code, OneWelcomeWrapperErrors.AUTHENTICATOR_NOT_FOUND.message, null)
    }

    @Test
    fun `should return error when authenticator id is not null but not found in SDK`() {
        whenever(userClientMock.authenticatedUserProfile).thenReturn(userProfile)
        whenever(callMock.argument<String>("authenticatorId")).thenReturn("testId")
        whenever(userClientMock.getAllAuthenticators(userProfile)).thenReturn(setOf(oneginiAuthenticator))
        whenever(oneginiAuthenticator.id).thenReturn("test")

        IsAuthenticatorRegisteredUseCase(clientMock)(callMock,resultSpy)

        verify(resultSpy).error(OneWelcomeWrapperErrors.AUTHENTICATOR_NOT_FOUND.code, OneWelcomeWrapperErrors.AUTHENTICATOR_NOT_FOUND.message, null)
    }

    @Test
    fun `should return true when authenticator id is registered`() {
        whenever(userClientMock.authenticatedUserProfile).thenReturn(userProfile)
        whenever(callMock.argument<String>("authenticatorId")).thenReturn("testId")
        whenever(userClientMock.getAllAuthenticators(userProfile)).thenReturn(setOf(oneginiAuthenticator))
        whenever(oneginiAuthenticator.id).thenReturn("testId")
        whenever(oneginiAuthenticator.isRegistered).thenReturn(true)

        IsAuthenticatorRegisteredUseCase(clientMock)(callMock,resultSpy)

        verify(resultSpy).success(true)
    }

    @Test
    fun `should return false when authenticator id is not registered`() {
        whenever(userClientMock.authenticatedUserProfile).thenReturn(userProfile)
        whenever(callMock.argument<String>("authenticatorId")).thenReturn("testId")
        whenever(userClientMock.getAllAuthenticators(userProfile)).thenReturn(setOf(oneginiAuthenticator))
        whenever(oneginiAuthenticator.id).thenReturn("testId")
        whenever(oneginiAuthenticator.isRegistered).thenReturn(false)

        IsAuthenticatorRegisteredUseCase(clientMock)(callMock,resultSpy)

        verify(resultSpy).success(false)
    }
}