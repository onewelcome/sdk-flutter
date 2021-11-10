package com.onegini.mobile.sdk

import com.google.gson.Gson
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.client.UserClient
import com.onegini.mobile.sdk.android.handlers.OneginiAuthenticationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiAuthenticationError
import com.onegini.mobile.sdk.android.model.OneginiAuthenticator
import com.onegini.mobile.sdk.android.model.entity.CustomInfo
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneginiWrapperErrors
import com.onegini.mobile.sdk.flutter.useCases.AuthenticateUserUseCase
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Mock
import org.mockito.Mockito
import org.mockito.Spy
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.any
import org.mockito.kotlin.eq
import org.mockito.kotlin.whenever

@RunWith(MockitoJUnitRunner::class)
class AuthenticateUserUseCaseTests {
    @Mock
    lateinit var clientMock: OneginiClient

    @Mock
    lateinit var userClientMock: UserClient

    @Spy
    lateinit var resultSpy: MethodChannel.Result

    @Mock
    lateinit var callMock: MethodCall

    @Mock
    lateinit var oneginiAuthenticatorMock: OneginiAuthenticator

    @Mock
    lateinit var oneginiAuthenticationErrorMock: OneginiAuthenticationError


    @Before
    fun attach() {
        whenever(clientMock.userClient).thenReturn(userClientMock)
    }

    @Test
    fun `should call result success with authenticator id as a param when given authenticator id is null`() {
        whenever(callMock.argument<String>("registeredAuthenticatorId")).thenReturn(null)
        whenever(userClientMock.userProfiles).thenReturn(setOf(UserProfile("QWERTY")))
        whenever(userClientMock.authenticateUser(eq(UserProfile("QWERTY")), any())).thenAnswer {
            it.getArgument<OneginiAuthenticationHandler>(1).onSuccess(UserProfile("QWERTY"), CustomInfo(0, ""))
        }

        AuthenticateUserUseCase(clientMock)(callMock, resultSpy)

        val userProfileJson = mapOf("profileId" to "QWERTY", "isDefault" to false)
        val customInfoJson = mapOf("data" to "", "status" to 0)
        val expectedResult = Gson().toJson(mapOf("userProfile" to userProfileJson, "customInfo" to customInfoJson))
        Mockito.verify(resultSpy).success(expectedResult)
    }

    @Test
    fun `should call result error when UserProfiles set is empty`() {
        whenever(callMock.argument<String>("registeredAuthenticatorId")).thenReturn(null)
        whenever(userClientMock.userProfiles).thenReturn(emptySet())

        AuthenticateUserUseCase(clientMock)(callMock, resultSpy)

        Mockito.verify(resultSpy).error(OneginiWrapperErrors.USER_PROFILE_IS_NULL.code, OneginiWrapperErrors.USER_PROFILE_IS_NULL.message, null)
    }

    @Test
    fun `should return error with authenticator id as a param when given authenticator id is not found`() {
        whenever(callMock.argument<String>("registeredAuthenticatorId")).thenReturn("TEST")
        whenever(userClientMock.userProfiles).thenReturn(setOf(UserProfile("QWERTY")))
        whenever(userClientMock.getRegisteredAuthenticators(eq(UserProfile("QWERTY")))).thenReturn(emptySet())

        AuthenticateUserUseCase(clientMock)(callMock, resultSpy)

        Mockito.verify(resultSpy).error(OneginiWrapperErrors.AUTHENTICATOR_NOT_FOUND.code, OneginiWrapperErrors.AUTHENTICATOR_NOT_FOUND.message, null)
    }

    @Test
    fun `should call result success with authenticator id as a param when given authenticator id is found`() {
        whenever(callMock.argument<String>("registeredAuthenticatorId")).thenReturn("TEST")
        whenever(userClientMock.userProfiles).thenReturn(setOf(UserProfile("QWERTY")))
        whenever(oneginiAuthenticatorMock.id).thenReturn("TEST")
        whenever(userClientMock.getRegisteredAuthenticators(eq(UserProfile("QWERTY")))).thenReturn(setOf(oneginiAuthenticatorMock))
        whenever(userClientMock.authenticateUser(eq(UserProfile("QWERTY")), eq(oneginiAuthenticatorMock), any())).thenAnswer {
            it.getArgument<OneginiAuthenticationHandler>(2).onSuccess(UserProfile("QWERTY"), CustomInfo(0, ""))
        }

        AuthenticateUserUseCase(clientMock)(callMock, resultSpy)

        val userProfileJson = mapOf("profileId" to "QWERTY", "isDefault" to false)
        val customInfoJson = mapOf("data" to "", "status" to 0)
        val expectedResult = Gson().toJson(mapOf("userProfile" to userProfileJson, "customInfo" to customInfoJson))
        Mockito.verify(resultSpy).success(expectedResult)
    }

    @Test
    fun `should call result error when authenticateUser return error`() {
        whenever(callMock.argument<String>("registeredAuthenticatorId")).thenReturn(null)
        whenever(userClientMock.userProfiles).thenReturn(setOf(UserProfile("QWERTY")))
        whenever(oneginiAuthenticationErrorMock.errorType).thenReturn(OneginiAuthenticationError.GENERAL_ERROR)
        whenever(oneginiAuthenticationErrorMock.message).thenReturn("General error")
        whenever(userClientMock.authenticateUser(eq(UserProfile("QWERTY")), any())).thenAnswer {
            it.getArgument<OneginiAuthenticationHandler>(1).onError(oneginiAuthenticationErrorMock)
        }

        AuthenticateUserUseCase(clientMock)(callMock, resultSpy)

        Mockito.verify(resultSpy).error(oneginiAuthenticationErrorMock.errorType.toString(), oneginiAuthenticationErrorMock.message, null)
    }

}