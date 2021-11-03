package com.onegini.mobile.sdk

import com.google.common.truth.Truth.assertThat
import com.google.gson.Gson
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.client.UserClient
import com.onegini.mobile.sdk.android.handlers.OneginiRegistrationHandler
import com.onegini.mobile.sdk.android.model.OneginiIdentityProvider
import com.onegini.mobile.sdk.android.model.entity.CustomInfo
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneginiWrapperErrors
import com.onegini.mobile.sdk.flutter.useCases.RegistrationUseCase
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.ArgumentMatchers.any
import org.mockito.Mock
import org.mockito.Mockito.verify
import org.mockito.Spy
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.*


@RunWith(MockitoJUnitRunner::class)
class RegistrationUseCaseTests {

    @Mock
    lateinit var clientMock: OneginiClient

    @Mock
    lateinit var userClientMock: UserClient

    @Spy
    lateinit var resultSpy: MethodChannel.Result

    @Mock
    lateinit var callMock: MethodCall

    @Mock
    lateinit var oneginiIdentityProviderMock: OneginiIdentityProvider

    @Before
    fun attach() {
        whenever(clientMock.userClient).thenReturn(userClientMock)
    }

    @Test
    fun `should call result success with identity provider id as a param when given identity provider id is null`() {
        whenever(callMock.argument<String>("identityProviderId")).thenReturn(null)
        whenever(callMock.argument<ArrayList<String>>("scopes")).thenReturn(arrayListOf("read"))
        whenever(userClientMock.registerUser(isNull(), eq(arrayOf("read")), any())).thenAnswer {
            it.getArgument<OneginiRegistrationHandler>(2).onSuccess(UserProfile("QWERTY"), CustomInfo(0, ""))
        }

        RegistrationUseCase(clientMock)(callMock, resultSpy)

        val expectedResult = Gson().toJson(mapOf("userProfile" to UserProfile("QWERTY"), "customInfo" to CustomInfo(0, "")))
        verify(resultSpy).success(expectedResult)
    }

    @Test
    fun `should match the IDs with the identity provider id as a parameter when the given ID is found in the SDK identity providers`() {
        val setOfIdentityProviders = setOf(oneginiIdentityProviderMock)

        whenever(oneginiIdentityProviderMock.id).thenReturn("testId")
        whenever(callMock.argument<String>("identityProviderId")).thenReturn("testId")
        whenever(callMock.argument<ArrayList<String>>("scopes")).thenReturn(arrayListOf("read"))
        whenever(userClientMock.identityProviders).thenReturn(setOfIdentityProviders)

        RegistrationUseCase(clientMock)(callMock, resultSpy)

        argumentCaptor<OneginiIdentityProvider> {
            verify(clientMock.userClient).registerUser(capture(), eq(arrayOf("read")), any())
            assertThat(firstValue.id).isEqualTo("testId")
        }
    }

    @Test
    fun `should return error when the given ID is not found in the SDK identity providers`() {
        val setOfIdentityProviders = setOf(oneginiIdentityProviderMock)

        whenever(oneginiIdentityProviderMock.id).thenReturn("test")
        whenever(callMock.argument<String>("identityProviderId")).thenReturn("testId")
        whenever(callMock.argument<ArrayList<String>>("scopes")).thenReturn(arrayListOf("read"))
        whenever(userClientMock.identityProviders).thenReturn(setOfIdentityProviders)

        RegistrationUseCase(clientMock)(callMock, resultSpy)

        verify(resultSpy).error(eq(OneginiWrapperErrors.IDENTITY_PROVIDER_NOT_FOUND.code), eq(OneginiWrapperErrors.IDENTITY_PROVIDER_NOT_FOUND.message), isNull())
    }

    @Test
    fun `should call result success with identity provider id as a param when given identity provider id is found in SDK identity providers`() {
        val setOfIdentityProviders = setOf(oneginiIdentityProviderMock)

        whenever(oneginiIdentityProviderMock.id).thenReturn("testId")
        whenever(callMock.argument<String>("identityProviderId")).thenReturn("testId")
        whenever(callMock.argument<ArrayList<String>>("scopes")).thenReturn(arrayListOf("read"))
        whenever(userClientMock.identityProviders).thenReturn(setOfIdentityProviders)
        whenever(userClientMock.registerUser(isNotNull(), eq(arrayOf("read")), any())).thenAnswer {
            it.getArgument<OneginiRegistrationHandler>(2).onSuccess(UserProfile("QWERTY"), CustomInfo(0, ""))
        }

        RegistrationUseCase(clientMock)(callMock, resultSpy)

        val expectedResult = Gson().toJson(mapOf("userProfile" to UserProfile("QWERTY"), "customInfo" to CustomInfo(0, "")))
        verify(resultSpy).success(expectedResult)
    }

    @Test
    fun `should call 'registerUser' method once when given identity provider id is null`() {
        whenever(callMock.argument<String>("identityProviderId")).thenReturn(null)
        whenever(callMock.argument<ArrayList<String>>("scopes")).thenReturn(arrayListOf("read"))

        RegistrationUseCase(clientMock)(callMock, resultSpy)

        verify(clientMock.userClient).registerUser(isNull(), eq(arrayOf("read")), any())
    }

    @Test
    fun `should scopes param be array of two scopes when given scopes contains two strings`() {
        whenever(callMock.argument<ArrayList<String>>("scopes")).thenReturn(arrayListOf("read", "write"))

        RegistrationUseCase(clientMock)(callMock, resultSpy)

        argumentCaptor<Array<String>> {
            verify(clientMock.userClient).registerUser(isNull(), capture(), any())
            assertThat(firstValue.size).isEqualTo(2)
            assertThat(firstValue).isEqualTo(arrayOf("read", "write"))
        }
    }

    @Test
    fun `should scopes param be array of zero lengths when given scopes is null`() {
        whenever(callMock.argument<ArrayList<String>>("scopes")).thenReturn(null)

        RegistrationUseCase(clientMock)(callMock, resultSpy)

        argumentCaptor<Array<String>> {
            verify(clientMock.userClient).registerUser(isNull(), capture(), any())
            assertThat(firstValue).isEmpty()
        }
    }
}