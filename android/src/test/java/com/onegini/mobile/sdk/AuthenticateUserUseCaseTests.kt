package com.onegini.mobile.sdk

import com.google.gson.Gson
import com.onegini.mobile.sdk.android.client.UserClient
import com.onegini.mobile.sdk.android.handlers.OneginiAuthenticationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiAuthenticationError
import com.onegini.mobile.sdk.android.model.OneginiAuthenticator
import com.onegini.mobile.sdk.android.model.entity.CustomInfo
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.useCases.AuthenticateUserUseCase
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
class AuthenticateUserUseCaseTests {
    @Mock(answer = Answers.RETURNS_DEEP_STUBS)
    lateinit var oneginiSdk: OneginiSDK

    @Spy
    lateinit var resultSpy: MethodChannel.Result

    @Mock
    lateinit var callMock: MethodCall

    @Mock
    lateinit var oneginiAuthenticatorMock: OneginiAuthenticator

    @Mock
    lateinit var oneginiAuthenticationErrorMock: OneginiAuthenticationError

    lateinit var authenticateUserUseCase: AuthenticateUserUseCase
    @Before
    fun attach() {
        authenticateUserUseCase = AuthenticateUserUseCase(oneginiSdk)
    }

    @Test
    fun `should call result success with authenticator id as a param when given authenticator id is null`() {
        whenever(callMock.argument<String>("registeredAuthenticatorId")).thenReturn(null)
        whenever(oneginiSdk.oneginiClient.userClient.userProfiles).thenReturn(setOf(UserProfile("QWERTY")))
        whenever(oneginiSdk.oneginiClient.userClient.authenticateUser(eq(UserProfile("QWERTY")), any())).thenAnswer {
            it.getArgument<OneginiAuthenticationHandler>(1).onSuccess(UserProfile("QWERTY"), CustomInfo(0, ""))
        }

        authenticateUserUseCase(callMock, resultSpy)

        val userProfileJson = mapOf("profileId" to "QWERTY", "isDefault" to false)
        val customInfoJson = mapOf("data" to "", "status" to 0)
        val expectedResult = Gson().toJson(mapOf("userProfile" to userProfileJson, "customInfo" to customInfoJson))
        verify(resultSpy).success(expectedResult)
    }

    @Test
    fun `should call result error when UserProfiles set is empty`() {
        whenever(callMock.argument<String>("registeredAuthenticatorId")).thenReturn(null)
        whenever(oneginiSdk.oneginiClient.userClient.userProfiles).thenReturn(emptySet())

        authenticateUserUseCase(callMock, resultSpy)

        val message = USER_PROFILE_DOES_NOT_EXIST.message
        verify(resultSpy).error(eq(USER_PROFILE_DOES_NOT_EXIST.code.toString()), eq(message), any())
    }

    @Test
    fun `should return error with authenticator id as a param when given authenticator id is not found`() {
        whenever(callMock.argument<String>("registeredAuthenticatorId")).thenReturn("TEST")
        whenever(oneginiSdk.oneginiClient.userClient.userProfiles).thenReturn(setOf(UserProfile("QWERTY")))
        whenever(oneginiSdk.oneginiClient.userClient.getRegisteredAuthenticators(eq(UserProfile("QWERTY")))).thenReturn(emptySet())

        authenticateUserUseCase(callMock, resultSpy)

        val message = AUTHENTICATOR_NOT_FOUND.message
        verify(resultSpy).error(eq(AUTHENTICATOR_NOT_FOUND.code.toString()), eq(message), any())
    }

    @Test
    fun `should call result success with authenticator id as a param when given authenticator id is found`() {
        whenever(callMock.argument<String>("registeredAuthenticatorId")).thenReturn("TEST")
        whenever(oneginiSdk.oneginiClient.userClient.userProfiles).thenReturn(setOf(UserProfile("QWERTY")))
        whenever(oneginiAuthenticatorMock.id).thenReturn("TEST")
        whenever(oneginiSdk.oneginiClient.userClient.getRegisteredAuthenticators(eq(UserProfile("QWERTY")))).thenReturn(setOf(oneginiAuthenticatorMock))
        whenever(oneginiSdk.oneginiClient.userClient.authenticateUser(eq(UserProfile("QWERTY")), eq(oneginiAuthenticatorMock), any())).thenAnswer {
            it.getArgument<OneginiAuthenticationHandler>(2).onSuccess(UserProfile("QWERTY"), CustomInfo(0, ""))
        }

        authenticateUserUseCase(callMock, resultSpy)

        val userProfileJson = mapOf("profileId" to "QWERTY", "isDefault" to false)
        val customInfoJson = mapOf("data" to "", "status" to 0)
        val expectedResult = Gson().toJson(mapOf("userProfile" to userProfileJson, "customInfo" to customInfoJson))
        verify(resultSpy).success(expectedResult)
    }

    @Test
    fun `should call result error when authenticateUser return error`() {
        whenever(callMock.argument<String>("registeredAuthenticatorId")).thenReturn(null)
        whenever(oneginiSdk.oneginiClient.userClient.userProfiles).thenReturn(setOf(UserProfile("QWERTY")))
        whenever(oneginiAuthenticationErrorMock.errorType).thenReturn(OneginiAuthenticationError.GENERAL_ERROR)
        whenever(oneginiAuthenticationErrorMock.message).thenReturn("General error")
        whenever(oneginiSdk.oneginiClient.userClient.authenticateUser(eq(UserProfile("QWERTY")), any())).thenAnswer {
            it.getArgument<OneginiAuthenticationHandler>(1).onError(oneginiAuthenticationErrorMock)
        }

        authenticateUserUseCase(callMock, resultSpy)

        val message = oneginiAuthenticationErrorMock.message
        verify(resultSpy).error(eq(oneginiAuthenticationErrorMock.errorType.toString()), eq(message), any())
    }

}