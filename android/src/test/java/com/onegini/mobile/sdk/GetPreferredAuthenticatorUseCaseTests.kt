package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.android.model.OneginiAuthenticator
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.SdkErrorAssert
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWAuthenticator
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWAuthenticatorType
import com.onegini.mobile.sdk.flutter.useCases.GetPreferredAuthenticatorUseCase
import com.onegini.mobile.sdk.flutter.useCases.GetUserProfileUseCase
import org.junit.Assert.assertEquals
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Answers
import org.mockito.Mock
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.any
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
        val getUserProfileUseCase = GetUserProfileUseCase(oneginiSdk)
        getPreferredAuthenticatorUseCase = GetPreferredAuthenticatorUseCase(oneginiSdk, getUserProfileUseCase)
    }

    @Test
    fun `When no userprofile does not exist, Then should reject with USER_PROFILE_DOES_NOT_EXIST`() {
        val result = getPreferredAuthenticatorUseCase(profileId)

        SdkErrorAssert.assertEquals(NOT_FOUND_USER_PROFILE, result.exceptionOrNull())
    }

    @Test
    fun `When the preferred authenticator is pin, Then should resolve with a pin authenticator`() {
        whenPreferedAuthenticatorIsPin()
        whenUserProfileExists()

        val result = getPreferredAuthenticatorUseCase(profileId)

        assertEquals(OWAuthenticatorType.PIN, result.getOrNull()?.authenticatorType)
    }

    @Test
    fun `When no preferred authenticator exists, Then we reject with a generic error`() {
        whenUserProfileExists()

        val result = getPreferredAuthenticatorUseCase(profileId)

        SdkErrorAssert.assertEquals(GENERIC_ERROR, result.exceptionOrNull())
    }

    @Test
    fun `When the preferred authenticator is biometric, Then should resolve with a biometric authenticator`() {
        whenPreferedAuthenticatorIsBiometric()
        whenUserProfileExists()

        val result = getPreferredAuthenticatorUseCase(profileId)

        assertEquals(OWAuthenticatorType.BIOMETRIC, result.getOrNull()?.authenticatorType)
    }

    @Test
    fun `When the preferred authenticator is not pin or fingerprint, Then should reject with a generic error`() {
        whenPreferedAuthenticatorIsCustom()
        whenUserProfileExists()

        val result = getPreferredAuthenticatorUseCase(profileId)

        SdkErrorAssert.assertEquals(GENERIC_ERROR, result.exceptionOrNull())
    }

    private fun whenUserProfileExists() {
        whenever(oneginiSdk.oneginiClient.userClient.userProfiles).thenReturn(setOf(UserProfile(profileId)))
    }

    private fun whenPreferedAuthenticatorIsPin() {
        whenever(oneginiAuthenticator.isPreferred).thenReturn(true)
        whenever(oneginiAuthenticator.type).thenReturn(OneginiAuthenticator.PIN)
        whenever(oneginiSdk.oneginiClient.userClient.getAllAuthenticators(any())).thenReturn(setOf(oneginiAuthenticator))
    }

    private fun whenPreferedAuthenticatorIsBiometric() {
        whenever(oneginiAuthenticator.isPreferred).thenReturn(true)
        whenever(oneginiAuthenticator.type).thenReturn(OneginiAuthenticator.FINGERPRINT)
        whenever(oneginiSdk.oneginiClient.userClient.getAllAuthenticators(any())).thenReturn(setOf(oneginiAuthenticator))
    }

    private fun whenPreferedAuthenticatorIsCustom() {
        whenever(oneginiAuthenticator.isPreferred).thenReturn(true)
        whenever(oneginiAuthenticator.type).thenReturn(OneginiAuthenticator.CUSTOM)
        whenever(oneginiSdk.oneginiClient.userClient.getAllAuthenticators(any())).thenReturn(setOf(oneginiAuthenticator))
    }
}
