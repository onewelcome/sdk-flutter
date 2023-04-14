package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.android.model.OneginiAuthenticator
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

    @Before
    fun attach() {
        getPreferredAuthenticatorUseCase = GetPreferredAuthenticatorUseCase(oneginiSdk)
    }

    @Test
    fun `When no user is authenticated, Then should reject with NO_USER_PROFILE_IS_AUTHENTICATED`() {
        WhenNoUserAuthenticated()

        getPreferredAuthenticatorUseCase(callbackMock)

        val captor = argumentCaptor<Result<OWAuthenticator>>()
        verify(callbackMock).invoke(captor.capture())
        SdkErrorAssert.assertEquals(NO_USER_PROFILE_IS_AUTHENTICATED, captor.firstValue.exceptionOrNull())
    }

    @Test
    fun `When the preferred authenticator is pin, Then should resolve with a pin authenticator`() {
        WhenPreferedAuthenticatorIsPin()

        getPreferredAuthenticatorUseCase(callbackMock)

        val captor = argumentCaptor<Result<OWAuthenticator>>()
        verify(callbackMock).invoke(captor.capture())
        assertEquals(captor.firstValue.getOrNull()?.authenticatorType, OWAuthenticatorType.PIN)
    }

    @Test
    fun `When the preferred authenticator is pin, Then should resolve with a biometric authenticator`() {
        WhenPreferedAuthenticatorIsBiometric()

        getPreferredAuthenticatorUseCase(callbackMock)

        val captor = argumentCaptor<Result<OWAuthenticator>>()
        verify(callbackMock).invoke(captor.capture())
        assertEquals(captor.firstValue.getOrNull()?.authenticatorType, OWAuthenticatorType.BIOMETRIC)
    }

    @Test
    fun `When the preferred authenticator is not pin or fingerprint, Then should reject with a generic error`() {
        WhenPreferedAuthenticatorIsCustom()

        getPreferredAuthenticatorUseCase(callbackMock)

        val captor = argumentCaptor<Result<OWAuthenticator>>()
        verify(callbackMock).invoke(captor.capture())
        SdkErrorAssert.assertEquals(GENERIC_ERROR, captor.firstValue.exceptionOrNull())
    }



    private fun WhenNoUserAuthenticated() {
        // preferredAuthenticator is null when no user is authenticated
        whenever(oneginiSdk.oneginiClient.userClient.preferredAuthenticator).thenReturn(null)
    }

    private fun WhenPreferedAuthenticatorIsPin() {
        whenever(oneginiAuthenticator.type).thenReturn(OneginiAuthenticator.PIN)
        whenever(oneginiSdk.oneginiClient.userClient.preferredAuthenticator).thenReturn(oneginiAuthenticator)
    }

    private fun WhenPreferedAuthenticatorIsBiometric() {
        whenever(oneginiAuthenticator.type).thenReturn(OneginiAuthenticator.FINGERPRINT)
        whenever(oneginiSdk.oneginiClient.userClient.preferredAuthenticator).thenReturn(oneginiAuthenticator)
    }

    private fun WhenPreferedAuthenticatorIsCustom() {
        whenever(oneginiAuthenticator.type).thenReturn(OneginiAuthenticator.CUSTOM)
        whenever(oneginiSdk.oneginiClient.userClient.preferredAuthenticator).thenReturn(oneginiAuthenticator)
    }

}
