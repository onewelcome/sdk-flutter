package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.android.model.OneginiAuthenticator
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.SdkErrorAssert
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWAuthenticator
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWAuthenticatorType
import com.onegini.mobile.sdk.flutter.useCases.GetPreferredAuthenticatorUseCase
import org.junit.Assert.assertEquals
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Answers
import org.mockito.Mock
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.any
import org.mockito.kotlin.argumentCaptor
import org.mockito.kotlin.verify
import org.mockito.kotlin.whenever

@RunWith(MockitoJUnitRunner::class)
class GetPreferredAuthenticatorUseCaseTests {
    @Mock(answer = Answers.RETURNS_DEEP_STUBS)
    lateinit var oneginiSdk: OneginiSDK

    @Mock
    lateinit var callbackMock: (Result<OWAuthenticator>) -> Unit

    @Mock(answer = Answers.RETURNS_SMART_NULLS)
    lateinit var oneginiAuthenticator: OneginiAuthenticator

    private lateinit var getPreferredAuthenticatorUseCase: GetPreferredAuthenticatorUseCase

    private val profileId = "QWERTY"
    @Before
    fun attach() {
        getPreferredAuthenticatorUseCase = GetPreferredAuthenticatorUseCase(oneginiSdk)
    }

    @Test
    fun `When no userprofile does not exist, Then should reject with USER_PROFILE_DOES_NOT_EXIST`() {
        getPreferredAuthenticatorUseCase(profileId, callbackMock)

        val captor = argumentCaptor<Result<OWAuthenticator>>()
        verify(callbackMock).invoke(captor.capture())
        SdkErrorAssert.assertEquals(USER_PROFILE_DOES_NOT_EXIST, captor.firstValue.exceptionOrNull())
    }

    @Test
    fun `When the preferred authenticator is pin, Then should resolve with a pin authenticator`() {
        WhenPreferedAuthenticatorIsPin()
        WhenUserProfileExists()

        getPreferredAuthenticatorUseCase(profileId, callbackMock)

        val captor = argumentCaptor<Result<OWAuthenticator>>()
        verify(callbackMock).invoke(captor.capture())
        assertEquals(OWAuthenticatorType.PIN, captor.firstValue.getOrNull()?.authenticatorType)
    }

    @Test
    fun `When no preferred authenticator exists, Then we reject with a generic error`() {
        WhenUserProfileExists()

        getPreferredAuthenticatorUseCase(profileId, callbackMock)

        val captor = argumentCaptor<Result<OWAuthenticator>>()
        verify(callbackMock).invoke(captor.capture())
        SdkErrorAssert.assertEquals(GENERIC_ERROR, captor.firstValue.exceptionOrNull())
    }

    @Test
    fun `When the preferred authenticator is biometric, Then should resolve with a biometric authenticator`() {
        WhenPreferedAuthenticatorIsBiometric()
        WhenUserProfileExists()

        getPreferredAuthenticatorUseCase(profileId, callbackMock)

        val captor = argumentCaptor<Result<OWAuthenticator>>()
        verify(callbackMock).invoke(captor.capture())
        assertEquals(OWAuthenticatorType.BIOMETRIC, captor.firstValue.getOrNull()?.authenticatorType)
    }

    @Test
    fun `When the preferred authenticator is not pin or fingerprint, Then should reject with a generic error`() {
        WhenPreferedAuthenticatorIsCustom()
        WhenUserProfileExists()

        getPreferredAuthenticatorUseCase(profileId, callbackMock)

        val captor = argumentCaptor<Result<OWAuthenticator>>()
        verify(callbackMock).invoke(captor.capture())
        SdkErrorAssert.assertEquals(GENERIC_ERROR, captor.firstValue.exceptionOrNull())
    }

    private fun WhenUserProfileExists() {
        whenever(oneginiSdk.oneginiClient.userClient.userProfiles).thenReturn(setOf(UserProfile(profileId)))
    }

    private fun WhenPreferedAuthenticatorIsPin() {
        whenever(oneginiAuthenticator.isPreferred).thenReturn(true)
        whenever(oneginiAuthenticator.type).thenReturn(OneginiAuthenticator.PIN)
        whenever(oneginiSdk.oneginiClient.userClient.getAllAuthenticators(any())).thenReturn(setOf(oneginiAuthenticator))
    }

    private fun WhenPreferedAuthenticatorIsBiometric() {
        whenever(oneginiAuthenticator.isPreferred).thenReturn(true)
        whenever(oneginiAuthenticator.type).thenReturn(OneginiAuthenticator.FINGERPRINT)
        whenever(oneginiSdk.oneginiClient.userClient.getAllAuthenticators(any())).thenReturn(setOf(oneginiAuthenticator))
    }

    private fun WhenPreferedAuthenticatorIsCustom() {
        whenever(oneginiAuthenticator.isPreferred).thenReturn(true)
        whenever(oneginiAuthenticator.type).thenReturn(OneginiAuthenticator.CUSTOM)
        whenever(oneginiSdk.oneginiClient.userClient.getAllAuthenticators(any())).thenReturn(setOf(oneginiAuthenticator))
    }
}
