package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.android.model.OneginiAuthenticator
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.SdkErrorAssert
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWAuthenticator
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWAuthenticatorType
import com.onegini.mobile.sdk.flutter.useCases.GetBiometricAuthenticatorUseCase
import com.onegini.mobile.sdk.flutter.useCases.GetUserProfileUseCase
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
class GetBiometricAuthenticatorUseCaseTests {
    @Mock(answer = Answers.RETURNS_DEEP_STUBS)
    lateinit var oneginiSdk: OneginiSDK

    @Mock
    lateinit var callbackMock: (Result<OWAuthenticator>) -> Unit

    @Mock(answer = Answers.RETURNS_SMART_NULLS)
    lateinit var oneginiAuthenticator: OneginiAuthenticator

    private lateinit var getBiometricAuthenticatorUseCase: GetBiometricAuthenticatorUseCase

    @Before
    fun attach() {
        val getUserProfileUseCase = GetUserProfileUseCase(oneginiSdk)
        getBiometricAuthenticatorUseCase = GetBiometricAuthenticatorUseCase(oneginiSdk, getUserProfileUseCase)
    }

    private val profileId = "QWERTY"

    @Test
    fun `When userProfile does not exist, Then should reject with USER_PROFILE_DOES_NOT_EXIST`() {
        getBiometricAuthenticatorUseCase(profileId, callbackMock)

        val captor = argumentCaptor<Result<OWAuthenticator>>()
        verify(callbackMock).invoke(captor.capture())
        SdkErrorAssert.assertEquals(USER_PROFILE_DOES_NOT_EXIST, captor.firstValue.exceptionOrNull())
    }

    @Test
    fun `When the biometric authenticator is not available, Then should reject with BIOMETRIC_AUTHENTICATION_NOT_AVAILABLE`() {
        whenUserProfileExists()

        getBiometricAuthenticatorUseCase(profileId, callbackMock)

        val captor = argumentCaptor<Result<OWAuthenticator>>()
        verify(callbackMock).invoke(captor.capture())
        SdkErrorAssert.assertEquals(BIOMETRIC_AUTHENTICATION_NOT_AVAILABLE, captor.firstValue.exceptionOrNull())
    }

    @Test
    fun `When the biometric authenticator is available, Then should resolve with the authenticator`() {
        whenUserProfileExists()
        whenBiometricAuthenticatorAvailable()

        getBiometricAuthenticatorUseCase(profileId, callbackMock)

        val captor = argumentCaptor<Result<OWAuthenticator>>()
        verify(callbackMock).invoke(captor.capture())
        assertEquals(captor.firstValue.getOrNull()?.authenticatorType, OWAuthenticatorType.BIOMETRIC)
    }


    private fun whenUserProfileExists() {
        whenever(oneginiSdk.oneginiClient.userClient.userProfiles).thenReturn(setOf(UserProfile(profileId)))
    }

    private fun whenBiometricAuthenticatorAvailable() {
        whenever(oneginiAuthenticator.type).thenReturn(OneginiAuthenticator.FINGERPRINT)
        whenever(oneginiSdk.oneginiClient.userClient.getAllAuthenticators(any())).thenReturn(setOf(oneginiAuthenticator))
    }

}
