package com.onegini.mobile.sdk

import com.google.gson.Gson
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.client.UserClient
import com.onegini.mobile.sdk.android.handlers.OneginiAuthenticatorRegistrationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiAuthenticatorRegistrationError
import com.onegini.mobile.sdk.android.model.OneginiAuthenticator
import com.onegini.mobile.sdk.android.model.entity.CustomInfo
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.useCases.RegisterAuthenticatorUseCase
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
class RegisterAuthenticatorUseCaseTests {

    @Mock(answer = Answers.RETURNS_DEEP_STUBS)
    lateinit var oneginiSdk: OneginiSDK

    @Mock
    lateinit var clientMock: OneginiClient



    @Mock
    lateinit var callMock: MethodCall

    @Mock
    lateinit var oneginiAuthenticatorMock: OneginiAuthenticator

    @Mock
    lateinit var oneginiAuthenticatorRegistrationErrorMock: OneginiAuthenticatorRegistrationError

    @Spy
    lateinit var resultSpy: MethodChannel.Result

    lateinit var registerAuthenticatorUseCase: RegisterAuthenticatorUseCase
    @Before
    fun attach() {
        registerAuthenticatorUseCase = RegisterAuthenticatorUseCase(oneginiSdk)
    }

    @Test
    fun `should return error when authenticatedUserProfile is null`() {
        whenever(oneginiSdk.oneginiClient.userClient.authenticatedUserProfile).thenReturn(null)

        registerAuthenticatorUseCase(callMock, resultSpy)

        val message = AUTHENTICATED_USER_PROFILE_IS_NULL.message
        verify(resultSpy).error(eq(AUTHENTICATED_USER_PROFILE_IS_NULL.code.toString()), eq(message), any())
    }

    @Test
    fun `should return error when given authenticator id is null`() {
        whenever(oneginiSdk.oneginiClient.userClient.authenticatedUserProfile).thenReturn(UserProfile("QWERTY"))
        whenever(oneginiSdk.oneginiClient.userClient.getNotRegisteredAuthenticators(eq(UserProfile("QWERTY")))).thenReturn(setOf(oneginiAuthenticatorMock))
        whenever(oneginiAuthenticatorMock.id).thenReturn("test")

        registerAuthenticatorUseCase(callMock, resultSpy)

        val message = AUTHENTICATOR_IS_NULL.message
        verify(resultSpy).error(eq(AUTHENTICATOR_IS_NULL.code.toString()), eq(message), any())
    }

    @Test
    fun `should return error when getNotRegisteredAuthenticators method returns empty set`() {
        whenever(callMock.argument<String>("authenticatorId")).thenReturn("test")
        whenever(oneginiSdk.oneginiClient.userClient.authenticatedUserProfile).thenReturn(UserProfile("QWERTY"))
        whenever(oneginiSdk.oneginiClient.userClient.getNotRegisteredAuthenticators(eq(UserProfile("QWERTY")))).thenReturn(emptySet())

        registerAuthenticatorUseCase(callMock, resultSpy)

        val message = AUTHENTICATOR_IS_NULL.message
        verify(resultSpy).error(eq(AUTHENTICATOR_IS_NULL.code.toString()), eq(message), any())
    }

    @Test
    fun `should return CustomInfo class with status and data as a params when given authenticator id found in getNotRegisteredAuthenticators method`() {
        whenever(callMock.argument<String>("authenticatorId")).thenReturn("test")
        whenever(oneginiSdk.oneginiClient.userClient.authenticatedUserProfile).thenReturn(UserProfile("QWERTY"))
        whenever(oneginiSdk.oneginiClient.userClient.getNotRegisteredAuthenticators(eq(UserProfile("QWERTY")))).thenReturn(setOf(oneginiAuthenticatorMock))
        whenever(oneginiAuthenticatorMock.id).thenReturn("test")
        whenever(oneginiSdk.oneginiClient.userClient.registerAuthenticator(eq(oneginiAuthenticatorMock), any())).thenAnswer {
            it.getArgument<OneginiAuthenticatorRegistrationHandler>(1).onSuccess(CustomInfo(0, "data"))
        }

        registerAuthenticatorUseCase(callMock, resultSpy)

        verify(resultSpy).success(Gson().toJson(CustomInfo(0, "data")))
    }

    @Test
    fun `should return error when registerAuthenticator method returns error`() {
        whenever(callMock.argument<String>("authenticatorId")).thenReturn("test")
        whenever(oneginiSdk.oneginiClient.userClient.authenticatedUserProfile).thenReturn(UserProfile("QWERTY"))
        whenever(oneginiSdk.oneginiClient.userClient.getNotRegisteredAuthenticators(eq(UserProfile("QWERTY")))).thenReturn(setOf(oneginiAuthenticatorMock))
        whenever(oneginiAuthenticatorMock.id).thenReturn("test")
        whenever(oneginiAuthenticatorRegistrationErrorMock.errorType).thenReturn(OneginiAuthenticatorRegistrationError.GENERAL_ERROR)
        whenever(oneginiAuthenticatorRegistrationErrorMock.message).thenReturn("General error")
        whenever(oneginiSdk.oneginiClient.userClient.registerAuthenticator(eq(oneginiAuthenticatorMock), any())).thenAnswer {
            it.getArgument<OneginiAuthenticatorRegistrationHandler>(1).onError(oneginiAuthenticatorRegistrationErrorMock)
        }

        registerAuthenticatorUseCase(callMock, resultSpy)

        val message = oneginiAuthenticatorRegistrationErrorMock.message
        verify(resultSpy).error(eq(oneginiAuthenticatorRegistrationErrorMock.errorType.toString()), eq(message), any())
    }
}