package com.onegini.mobile.sdk

import com.google.common.truth.Truth.assertThat
import com.google.gson.Gson
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.handlers.OneginiRegistrationHandler
import com.onegini.mobile.sdk.android.model.OneginiIdentityProvider
import com.onegini.mobile.sdk.android.model.entity.CustomInfo
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.useCases.RegistrationUseCase
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Answers
import org.mockito.ArgumentMatchers.any
import org.mockito.Mock
import org.mockito.Spy
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.*

@RunWith(MockitoJUnitRunner::class)
class RegistrationUseCaseTests {

    @Mock(answer = Answers.RETURNS_DEEP_STUBS)
    lateinit var oneginiSdk: OneginiSDK

    @Mock
    lateinit var clientMock: OneginiClient
    @Spy
    lateinit var resultSpy: MethodChannel.Result

    @Mock
    lateinit var callMock: MethodCall

    @Mock
    lateinit var oneginiIdentityProviderMock: OneginiIdentityProvider

    lateinit var registrationUseCase: RegistrationUseCase

    @Before
    fun attach() {
        registrationUseCase = RegistrationUseCase(oneginiSdk)
    }

    @Test
    fun `should call result success with identity provider id as a param when given identity provider id is null`() {
        whenever(callMock.argument<String>("identityProviderId")).thenReturn(null)
        whenever(callMock.argument<ArrayList<String>>("scopes")).thenReturn(arrayListOf("read"))
        whenever(oneginiSdk.oneginiClient.userClient.registerUser(isNull(), eq(arrayOf("read")), any())).thenAnswer {
            it.getArgument<OneginiRegistrationHandler>(2).onSuccess(UserProfile("QWERTY"), CustomInfo(0, ""))
        }

        registrationUseCase(callMock, resultSpy)

        val userProfileJson = mapOf("profileId" to "QWERTY", "isDefault" to false)
        val customInfoJson = mapOf("data" to "", "status" to 0)
        val expectedResult = Gson().toJson(mapOf("userProfile" to userProfileJson, "customInfo" to customInfoJson))
       
        verify(resultSpy).success(expectedResult)
    }

    @Test
    fun `should match the IDs with the identity provider id as a parameter when the given ID is found in the SDK identity providers`() {
        val setOfIdentityProviders = setOf(oneginiIdentityProviderMock)

        whenever(oneginiIdentityProviderMock.id).thenReturn("testId")
        whenever(callMock.argument<String>("identityProviderId")).thenReturn("testId")
        whenever(callMock.argument<ArrayList<String>>("scopes")).thenReturn(arrayListOf("read"))
        whenever(oneginiSdk.oneginiClient.userClient.identityProviders).thenReturn(setOfIdentityProviders)

        registrationUseCase(callMock, resultSpy)

        argumentCaptor<OneginiIdentityProvider> {
            verify(oneginiSdk.oneginiClient.userClient).registerUser(capture(), eq(arrayOf("read")), any())
            assertThat(firstValue.id).isEqualTo("testId")
        }
    }

    @Test
    fun `should return error when the given ID is not found in the SDK identity providers`() {
        val setOfIdentityProviders = setOf(oneginiIdentityProviderMock)

        whenever(oneginiIdentityProviderMock.id).thenReturn("test")
        whenever(callMock.argument<String>("identityProviderId")).thenReturn("testId")
        whenever(callMock.argument<ArrayList<String>>("scopes")).thenReturn(arrayListOf("read"))
        whenever(oneginiSdk.oneginiClient.userClient.identityProviders).thenReturn(setOfIdentityProviders)

        registrationUseCase(callMock, resultSpy)

        verify(resultSpy).error(eq(IDENTITY_PROVIDER_NOT_FOUND.code.toString()), eq(IDENTITY_PROVIDER_NOT_FOUND.message), any())
    }

    @Test
    fun `should call result success with identity provider id as a param when given identity provider id is found in SDK identity providers`() {
        val setOfIdentityProviders = setOf(oneginiIdentityProviderMock)

        whenever(oneginiIdentityProviderMock.id).thenReturn("testId")
        whenever(callMock.argument<String>("identityProviderId")).thenReturn("testId")
        whenever(callMock.argument<ArrayList<String>>("scopes")).thenReturn(arrayListOf("read"))
        whenever(oneginiSdk.oneginiClient.userClient.identityProviders).thenReturn(setOfIdentityProviders)
        whenever(oneginiSdk.oneginiClient.userClient.registerUser(isNotNull(), eq(arrayOf("read")), any())).thenAnswer {
            it.getArgument<OneginiRegistrationHandler>(2).onSuccess(UserProfile("QWERTY"), CustomInfo(0, ""))
        }

        registrationUseCase(callMock, resultSpy)

        val userProfileJson = mapOf("profileId" to "QWERTY", "isDefault" to false)
        val customInfoJson = mapOf("data" to "", "status" to 0)
        val expectedResult = Gson().toJson(mapOf("userProfile" to userProfileJson, "customInfo" to customInfoJson))
        verify(resultSpy).success(expectedResult)
    }

    @Test
    fun `should call 'registerUser' method once when given identity provider id is null`() {
        whenever(callMock.argument<String>("identityProviderId")).thenReturn(null)
        whenever(callMock.argument<ArrayList<String>>("scopes")).thenReturn(arrayListOf("read"))

        registrationUseCase(callMock, resultSpy)

        verify(oneginiSdk.oneginiClient.userClient).registerUser(isNull(), eq(arrayOf("read")), any())
    }

    @Test
    fun `should scopes param be array of two scopes when given scopes contains two strings`() {
        whenever(callMock.argument<ArrayList<String>>("scopes")).thenReturn(arrayListOf("read", "write"))

        registrationUseCase(callMock, resultSpy)

        argumentCaptor<Array<String>> {
            verify(oneginiSdk.oneginiClient.userClient).registerUser(isNull(), capture(), any())
            assertThat(firstValue.size).isEqualTo(2)
            assertThat(firstValue).isEqualTo(arrayOf("read", "write"))
        }
    }

    @Test
    fun `should scopes param be array of zero lengths when given scopes is null`() {
        whenever(callMock.argument<ArrayList<String>>("scopes")).thenReturn(null)

        registrationUseCase(callMock, resultSpy)

        argumentCaptor<Array<String>> {
            verify(oneginiSdk.oneginiClient.userClient).registerUser(isNull(), capture(), any())
            assertThat(firstValue).isEmpty()
        }
    }
}