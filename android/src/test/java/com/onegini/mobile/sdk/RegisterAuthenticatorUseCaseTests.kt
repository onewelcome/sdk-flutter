package com.onegini.mobile.sdk

import com.google.gson.Gson
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.handlers.OneginiAuthenticatorRegistrationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiAuthenticatorRegistrationError
import com.onegini.mobile.sdk.android.model.OneginiAuthenticator
import com.onegini.mobile.sdk.android.model.entity.CustomInfo
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.pigeonPlugin.FlutterError
import com.onegini.mobile.sdk.flutter.useCases.RegisterAuthenticatorUseCase
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Answers
import org.mockito.Mock
import org.mockito.Spy
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.any
import org.mockito.kotlin.argumentCaptor
import org.mockito.kotlin.eq
import org.mockito.kotlin.times
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

    @Mock
    lateinit var callbackMock: (Result<Unit>) -> Unit

    @Spy
    lateinit var resultSpy: MethodChannel.Result

    lateinit var registerAuthenticatorUseCase: RegisterAuthenticatorUseCase
    @Before
    fun attach() {
        registerAuthenticatorUseCase = RegisterAuthenticatorUseCase(oneginiSdk)
    }

    @Test
    fun `When no user is authenticated, Then it should return error`() {
        whenever(oneginiSdk.oneginiClient.userClient.authenticatedUserProfile).thenReturn(null)

        registerAuthenticatorUseCase("test", callbackMock)

        argumentCaptor<Result<Unit>>().apply {
            verify(callbackMock, times(1)).invoke(capture())
            when (val error = firstValue.exceptionOrNull()) {
                is FlutterError -> {
                    Assert.assertEquals(error.code.toInt(), NO_USER_PROFILE_IS_AUTHENTICATED.code)
                    Assert.assertEquals(error.message, NO_USER_PROFILE_IS_AUTHENTICATED.message)
                }
                else -> junit.framework.Assert.fail(UNEXPECTED_ERROR_TYPE.message)
            }
        }
    }

    @Test
    fun `When authenticator id is not recognised, Then it should return error`() {
        whenever(oneginiSdk.oneginiClient.userClient.authenticatedUserProfile).thenReturn(UserProfile("QWERTY"))
        whenever(oneginiSdk.oneginiClient.userClient.getNotRegisteredAuthenticators(eq(UserProfile("QWERTY")))).thenReturn(setOf(oneginiAuthenticatorMock))
        whenever(oneginiAuthenticatorMock.id).thenReturn("other_test")

        registerAuthenticatorUseCase("test", callbackMock)

        argumentCaptor<Result<Unit>>().apply {
            verify(callbackMock, times(1)).invoke(capture())
            when (val error = firstValue.exceptionOrNull()) {
                is FlutterError -> {
                    Assert.assertEquals(error.code.toInt(), AUTHENTICATOR_NOT_FOUND.code)
                    Assert.assertEquals(error.message, AUTHENTICATOR_NOT_FOUND.message)
                }
                else -> junit.framework.Assert.fail(UNEXPECTED_ERROR_TYPE.message)
            }
        }
    }

    @Test
    fun `When the user has an empty set of authenticators, Then an error should be returned`() {
        whenever(oneginiSdk.oneginiClient.userClient.authenticatedUserProfile).thenReturn(UserProfile("QWERTY"))
        whenever(oneginiSdk.oneginiClient.userClient.getNotRegisteredAuthenticators(eq(UserProfile("QWERTY")))).thenReturn(emptySet())

        registerAuthenticatorUseCase("test", callbackMock)

        argumentCaptor<Result<Unit>>().apply {
            verify(callbackMock, times(1)).invoke(capture())
            when (val error = firstValue.exceptionOrNull()) {
                is FlutterError -> {
                    Assert.assertEquals(error.code.toInt(), AUTHENTICATOR_NOT_FOUND.code)
                    Assert.assertEquals(error.message, AUTHENTICATOR_NOT_FOUND.message)
                }
                else -> junit.framework.Assert.fail(UNEXPECTED_ERROR_TYPE.message)
            }
        }
    }

    @Test
    fun `should return CustomInfo class with status and data as a params when given authenticator id found in getNotRegisteredAuthenticators method`() {
        whenever(oneginiSdk.oneginiClient.userClient.authenticatedUserProfile).thenReturn(UserProfile("QWERTY"))
        whenever(oneginiSdk.oneginiClient.userClient.getNotRegisteredAuthenticators(eq(UserProfile("QWERTY")))).thenReturn(setOf(oneginiAuthenticatorMock))
        whenever(oneginiAuthenticatorMock.id).thenReturn("test")
        whenever(oneginiSdk.oneginiClient.userClient.registerAuthenticator(eq(oneginiAuthenticatorMock), any())).thenAnswer {
            it.getArgument<OneginiAuthenticatorRegistrationHandler>(1).onSuccess(CustomInfo(0, "data"))
        }

        registerAuthenticatorUseCase("test", callbackMock)

//        fixme
//        argumentCaptor<Result<Unit>>().apply {
//            verify(callbackMock, times(1)).invoke(capture())
//            Assert.assertEquals(firstValue.getOrNull(), Unit)
//        }
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

//        registerAuthenticatorUseCase(callMock, resultSpy)

        val message = oneginiAuthenticatorRegistrationErrorMock.message
        verify(resultSpy).error(eq(oneginiAuthenticatorRegistrationErrorMock.errorType.toString()), eq(message), any())
    }
}
