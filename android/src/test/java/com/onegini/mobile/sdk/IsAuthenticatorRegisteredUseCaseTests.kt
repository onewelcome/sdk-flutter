package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.model.OneginiAuthenticator
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.useCases.IsAuthenticatorRegisteredUseCase
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
class IsAuthenticatorRegisteredUseCaseTests {

    @Mock(answer = Answers.RETURNS_DEEP_STUBS)
    lateinit var oneginiSdk: OneginiSDK

    @Mock
    lateinit var clientMock: OneginiClient
    @Mock
    lateinit var callMock: MethodCall

    @Mock
    lateinit var userProfile: UserProfile

    @Mock
    lateinit var oneginiAuthenticator: OneginiAuthenticator

    @Spy
    lateinit var resultSpy: MethodChannel.Result

    lateinit var isAuthenticatorRegisteredUseCase: IsAuthenticatorRegisteredUseCase

    @Before
    fun attach() {
        isAuthenticatorRegisteredUseCase = IsAuthenticatorRegisteredUseCase(oneginiSdk)
    }

    @Test
    fun `should return error when user is not authenticated`() {
        whenever(callMock.argument<String>("authenticatorId")).thenReturn("TEST")
        whenever(oneginiSdk.oneginiClient.userClient.authenticatedUserProfile).thenReturn(null)

        isAuthenticatorRegisteredUseCase(callMock,resultSpy)

        val message = NO_USER_PROFILE_IS_AUTHENTICATED.message
        verify(resultSpy).error(eq(NO_USER_PROFILE_IS_AUTHENTICATED.code.toString()), eq(message), any())
    }

    @Test
    fun `should return error when authenticator id is null`() {
        whenever(callMock.argument<String>("authenticatorId")).thenReturn("TEST")
        whenever(oneginiSdk.oneginiClient.userClient.authenticatedUserProfile).thenReturn(userProfile)

        isAuthenticatorRegisteredUseCase(callMock,resultSpy)

        val message = AUTHENTICATOR_NOT_FOUND.message
        verify(resultSpy).error(eq(AUTHENTICATOR_NOT_FOUND.code.toString()), eq(message), any())
    }

    @Test
    fun `should return error when authenticator id is not null but not found in SDK`() {
        whenever(oneginiSdk.oneginiClient.userClient.authenticatedUserProfile).thenReturn(userProfile)
        whenever(callMock.argument<String>("authenticatorId")).thenReturn("testId")
        whenever(oneginiSdk.oneginiClient.userClient.getAllAuthenticators(userProfile)).thenReturn(setOf(oneginiAuthenticator))
        whenever(oneginiAuthenticator.id).thenReturn("test")

        isAuthenticatorRegisteredUseCase(callMock,resultSpy)

        val message = AUTHENTICATOR_NOT_FOUND.message
        verify(resultSpy).error(eq(AUTHENTICATOR_NOT_FOUND.code.toString()), eq(message), any())
    }

    @Test
    fun `should return true when authenticator id is registered`() {
        whenever(oneginiSdk.oneginiClient.userClient.authenticatedUserProfile).thenReturn(userProfile)
        whenever(callMock.argument<String>("authenticatorId")).thenReturn("testId")
        whenever(oneginiSdk.oneginiClient.userClient.getAllAuthenticators(userProfile)).thenReturn(setOf(oneginiAuthenticator))
        whenever(oneginiAuthenticator.id).thenReturn("testId")
        whenever(oneginiAuthenticator.isRegistered).thenReturn(true)

        isAuthenticatorRegisteredUseCase(callMock,resultSpy)

        verify(resultSpy).success(true)
    }

    @Test
    fun `should return false when authenticator id is not registered`() {
        whenever(oneginiSdk.oneginiClient.userClient.authenticatedUserProfile).thenReturn(userProfile)
        whenever(callMock.argument<String>("authenticatorId")).thenReturn("testId")
        whenever(oneginiSdk.oneginiClient.userClient.getAllAuthenticators(userProfile)).thenReturn(setOf(oneginiAuthenticator))
        whenever(oneginiAuthenticator.id).thenReturn("testId")
        whenever(oneginiAuthenticator.isRegistered).thenReturn(false)

        isAuthenticatorRegisteredUseCase(callMock,resultSpy)

        verify(resultSpy).success(false)
    }
}